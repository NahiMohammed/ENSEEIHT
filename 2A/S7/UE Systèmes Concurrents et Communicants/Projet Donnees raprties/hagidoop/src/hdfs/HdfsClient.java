package hdfs;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

import interfaces.FileReaderWriter;
import interfaces.KV;
import interfaces.KVReaderWriterImpl;
import interfaces.LineReaderWriterImpl;

public class HdfsClient {

	private static List<String> listeMachine = new ArrayList<>();
	private static int nbMachines = 0;

	public HdfsClient() {
		try {

			// Récupérer le nom des machines (ou les adresses IP ) depuis le fichier
			// config/listeMachines.txt
			BufferedReader reader = new BufferedReader(new FileReader("config/listeMachines.txt"));
			String line;
			while ((line = reader.readLine()) != null) {
				listeMachine.add(line);
				nbMachines += 1;
			}
			System.out.println("le nombre de machines est " + nbMachines);
			reader.close();

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	private static void usage() {
		System.out.println("Usage: java HdfsClient read <file>");
		System.out.println("Usage: java HdfsClient write <txt|kv> <file>");
		System.out.println("Usage: java HdfsClient delete <file>");
	}

	private static int nombreDeLignes(String cheminDuFichier) {
		int nombreDeLignes = 0;

		try (BufferedReader lecteur = new BufferedReader(new FileReader(cheminDuFichier))) {
			// Lire le fichier ligne par ligne
			while (lecteur.readLine() != null) {
				nombreDeLignes++;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		return nombreDeLignes;
	}

	public static void HdfsDelete(String fname) {

		System.out.println("Demande de suppression des fichiers ...");
		try {

			int numfragment = 0;
			while (numfragment < nbMachines) {
				int numServeur = numfragment;

				Socket sock = new Socket(listeMachine.get(numServeur), (6001 + numServeur));
				ObjectOutputStream oos = new ObjectOutputStream(sock.getOutputStream());

				oos.writeObject(Commande.CMD_DELETE);
				String[] inter = fname.split("\\.");
				String nom = inter[0];

				String extension = inter[1];
				oos.writeObject("data/" + nom + "_" + numServeur + "-res" + "." + extension);
				oos.flush();
				oos.writeObject("data/" + nom + "_" + numServeur + "." + extension);
				oos.flush();
				oos.close();
				sock.close();
				numfragment++;

			}

			System.out.println("Les fichiers ont ete supprime avec succes");
		} catch (Exception e) {
			System.out.println("Erreur HdfdDelate (Client)");
			e.printStackTrace();
		}

	}

	public static void HdfsWrite(int fmt, String fname) throws UnknownHostException, IOException {

		try {

			int index;
			KV buffer = new KV();

			File file = new File("data/" + fname);
			long taille = file.length();

			int nbfragments = nbMachines;
			System.out.println("Le nombre de ligne dans le fichier d'origine est  " + nombreDeLignes("data/" + fname));

			int taillefragments = (int) ((nombreDeLignes("data/" + fname)) / nbMachines);

			System.out.println("Chaque fragment contient fragments :" + taillefragments + "lignes");

			if (fmt == 0) {
				LineReaderWriterImpl fichier = new LineReaderWriterImpl("data/" + fname);
				fichier.open("Read");
				for (int i = 0; i < nbfragments; i++) {
					ArrayList<KV> fragment = new ArrayList<KV>();
					index = 0;

					while (index < taillefragments) {
						buffer = fichier.read();
						if (buffer == null) {
							break;
						} else {
							fragment.add(buffer);
							index = (int) (fichier.getIndex() - i * taillefragments);
						}
					}

					System.out.println("attempt to connect to Machine numero " + String.valueOf(i + 1) + " num port :"
							+ String.valueOf(6001 + i));

					Socket socket = new Socket(listeMachine.get(i), (6001 + i));

					System.out.println("Connection Réussite");

					System.out.println("Début d'envoi du fragment numéro " + Integer.toString(i + 1)
							+ "a machine numero " + String.valueOf(i + 1));

					String[] inter = fname.split("\\.");
					String nom = inter[0];

					String extension = inter[1];
					ObjectOutputStream objectOS = new ObjectOutputStream(socket.getOutputStream());

					LineReaderWriterImpl fichier_sent = new LineReaderWriterImpl(
							"data/" + nom + "_" + i + "." + extension);

					objectOS.writeObject(Commande.CMD_WRITE);
					objectOS.flush();
					objectOS.writeObject("data/" + nom + "_" + i + "." + extension);
					objectOS.flush();
					objectOS.writeObject(fichier_sent);
					objectOS.flush();

					for (KV kv : fragment) {
						objectOS.writeObject(kv);
						objectOS.flush();
					}
					objectOS.writeObject("fini");
					objectOS.flush();
					objectOS.close();
					objectOS.close();
				}
				fichier.close();

			} else if (fmt == 1) {
				KVReaderWriterImpl fichier = new KVReaderWriterImpl("data/" + fname);
				fichier.open("Read");
				for (int i = 0; i < nbfragments; i++) {
					ArrayList<KV> fragment = new ArrayList<KV>();
					index = 0;

					while (index < taillefragments) {
						buffer = fichier.read();
						if (buffer == null) {
							break;
						}
						fragment.add(buffer);
						index = (int) (fichier.getIndex() - i * taillefragments);
					}
					System.out.println("attempt to connect to Machine numero " + String.valueOf(i + 1) + " num port :"
							+ String.valueOf(6000 + i) + "...");

					Socket socket = new Socket(listeMachine.get(i), (6001 + i));

					System.out.println("Connection Réussite");

					System.out.println("Début d'envoi du fragment numéro " + Integer.toString(i + 1)
							+ "a machine numero " + String.valueOf(i + 1));

					String[] inter = fname.split("\\.");
					String nom = inter[0];
					String extension = inter[1];
					ObjectOutputStream objectOS = new ObjectOutputStream(socket.getOutputStream());

					KVReaderWriterImpl fichier_sent = new KVReaderWriterImpl("data/" + nom + "_" + i + "." + extension);

					objectOS.writeObject(Commande.CMD_WRITE);
					objectOS.flush();
					objectOS.writeObject("data/" + nom + "_" + i + "." + extension);
					objectOS.flush();
					objectOS.writeObject(fichier_sent);
					objectOS.flush();

					for (KV kv : fragment) {
						objectOS.writeObject(kv);
						objectOS.flush();
					}
					System.out.println("fini");
					objectOS.flush();
					objectOS.close();
					objectOS.close();
				}
				fichier.close();

			}
		} catch (Exception e) {
			System.out.println("ERREUR HdfdWrite (Client)");
			e.printStackTrace();
		}

	}

	public void HdfsRead(String fname) {
		String[] inter = fname.split("\\.");
		String nom = inter[0];
		String extension = inter[1];

		File file = new File("data/ReasultatRead.txt");

		try {
			int j;
			System.out.println("Deamnde de Lecture des fichiers ...");
			FileWriter fWrite = new FileWriter(file);
			int nbfragments = nbMachines;
			for (int i = 0; i < nbfragments; i++) {

				Socket socket = new Socket(listeMachine.get(i), 6001 + i);
				ObjectOutputStream objectOS = new ObjectOutputStream(socket.getOutputStream());
				objectOS.writeObject(Commande.CMD_READ);
				objectOS.flush();
				objectOS.writeObject("data/" + nom + "_" + i + "-res" + "." + extension);
				objectOS.flush();
				ObjectInputStream objectIS = new ObjectInputStream(socket.getInputStream());
				String fragment = (String) objectIS.readObject();
				fWrite.write(fragment, 0, fragment.length());
				objectIS.close();
				objectOS.close();
				socket.close();
			}
			fWrite.close();
			System.out.println("Lecture Terminé avec succes...");
			System.out.println("Un fichier de nom ReasultatRead.txt a été crée dans le dossier data");
		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

	public static void main(String[] args) {
		// java HdfsClient <read|write> <txt|kv> <file>
		// appel des méthodes précédentes depuis la ligne de commande

		try {

			HdfsClient hc = new HdfsClient();

			if (args.length < 2) {
				usage();
				return;
			}

			switch (args[0]) {

			case "write":
				int fmt;
				if (args.length < 3) {
					usage();
					return;
				}
				if (args[1].equals("line"))
					fmt = 0;
				else if (args[1].equals("kv"))
					fmt = 1;
				else {
					usage();
					return;
				}
				hc.HdfsWrite(fmt, args[2]);
				break;

			case "delete":
				hc.HdfsDelete(args[1]);
				break;
			case "read":
				hc.HdfsRead(args[1]);
				break;

			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

}
