package hdfs;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;

import interfaces.FileReaderWriter;
import interfaces.KV;

public class HdfsServer extends Thread {

	private Socket sock;

	public static void main(String[] args) throws IOException {

		int port = Integer.parseInt(args[0]);

		ServerSocket ss;
		ss = new ServerSocket(port);
		System.out.println("============>>>>Serveur démarré sur le port : " + args[0]);

		while (true) {
			// Creation d'un thread
			Thread t = new HdfsServer(ss.accept());
			t.start();
		}
	}

	public HdfsServer(Socket s) {
		this.sock = s;
	}

	public void run() {
		try {
			ObjectOutputStream oos = new ObjectOutputStream(sock.getOutputStream());
			ObjectInputStream ois = new ObjectInputStream(sock.getInputStream());

			// Lecture de la commande
			Commande cmd = (Commande) ois.readObject();

			switch (cmd) {

			case CMD_WRITE:

				System.out.println("Demande d'écriture reçue par le serveur ...");
				// Lecture du nom du fichier
				String fnameW = (String) ois.readObject();
				FileReaderWriter fmt = (FileReaderWriter) ois.readObject();
				fmt.open("Write");
				Object o;
				while ((o = ois.readObject()) instanceof KV) {

					fmt.write((KV) o);
				}
				fmt.close();
				System.out.println("Fin demande écriture reçue par le serveur " + sock.getLocalPort());
				System.out.println("DONE");
				break;

			case CMD_DELETE:
				System.out.println("Demande de suppresion reçue par le serveur...");
				String fnameD1 = (String) ois.readObject();
				File f1 = new File(fnameD1);
				f1.delete();
				String fnameD2 = (String) ois.readObject();
				File f2 = new File(fnameD2);
				f2 .delete();
				break;
			case CMD_READ:

				System.out.println("Demande de lecture reçue par le serveur");
				// Lecture du nom du fichier
				String fnameR = (String) ois.readObject();

				FileReader fr = new FileReader(fnameR);
				BufferedReader buff = new BufferedReader(fr);
				// Message à envoyer
				String str = new String();
				String line;
				while ((line = buff.readLine()) != null) {
					str += line + "\n";
				}
				buff.close();
				oos.writeObject(str);
				System.out.println("DONE");

				break;

			default:
				break;

			}

			ois.close();
			oos.close();
			sock.close();

		} catch (ClassNotFoundException e) {
			System.out.println("Error dans HDFS Server");
			e.printStackTrace();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (IOException e) {
			System.out.println("Erreur écriture/serveur " + sock.getLocalPort());
			e.printStackTrace();
		}

	}
}