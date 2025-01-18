package daemon;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;

import application.MyMapReduce;
import hdfs.HdfsClient;
import hdfs.HdfsServer;
import interfaces.FileReaderWriter;
import interfaces.KVReaderWriterImpl;
import interfaces.LineReaderWriterImpl;
import interfaces.MapReduce;

public class JobLauncher {
	private static int nbWorkers = 0;

	private static List<String> listeMachines = new ArrayList<>();

	private static List<Worker> listeWorkers = new ArrayList<>();
	private static String[] urls = new String[nbWorkers];

	private static void setWorkers() throws IOException {
		BufferedReader reader1 = new BufferedReader(new FileReader("config/listeMachines.txt"));
		String line;
		while ((line = reader1.readLine()) != null) {
			listeMachines.add(line);
			nbWorkers += 1;
		}
		urls = new String[nbWorkers];
	}

	

	

	public static void startJob(MapReduce mr, int format, String fname)
			throws NotBoundException, IOException, InterruptedException {
		setWorkers();


		int nbFragments = nbWorkers;

		String[] nomExt = fname.split("\\.");
		String fsce;
		String fdest;
		FileReaderWriter reader;
		FileReaderWriter writer;

		System.out.println(nbWorkers);

		for (int i = 0; i < nbWorkers; i++) {
			urls[i] = ("//" + listeMachines.get(i) + ":" + String.valueOf(1001 + i) + "/Worker");
			listeWorkers.add((Worker) Naming.lookup(urls[i]));
		}

		for (int i = 0; i < nbFragments; i++) {

			// format des noms de fragments : "<nom fichier HDFS>_< n° fragment
			// >.<Extention>"
			fsce = "data/" + nomExt[0] + "_" + i + "." + nomExt[1];

			// fragment destination : ajouter le suffixe "-res";
			fdest = "data/" + nomExt[0] + "_" + i + "-res" + "." + nomExt[1];

			reader = new LineReaderWriterImpl(fsce);
			writer = new KVReaderWriterImpl(fdest);
            
			listeWorkers.get(i).runMap(mr, reader, writer);
			//listeWorkers.get(i).runMap(mr, reader, writer, i, completionStatus);
			// Wait for all tasks to finish
			// boolean allCompleted = false;
			// while (!allCompleted) {
			// allCompleted = true;
			// for (boolean status : completionStatus) {
			// if (!status) {
			// allCompleted = false;
			// break;
			// }
			// }
			
			
			
			
			System.out.println("Termineee");
			
			
			
			
			

		}

	}

	private static void usage() {
		System.out.println("Utilisation : java JobLauncher fichier format");
	}

	public static void main(String args[])
			throws NotBoundException, NumberFormatException, IOException, InterruptedException {
		try {
			// Nom du fichier sur lequel appliquer le traitement
			String hdfsFname = args[0];
			String[] nomExt = hdfsFname.split("\\.");

			
			

			MyMapReduce mr = new MyMapReduce();
			System.out.println("Lancement du Job");
			long t1 = System.currentTimeMillis();
			startJob(mr, Integer.valueOf(args[1]), hdfsFname);
			HdfsClient client;
			try {
				client = new HdfsClient();
				client.HdfsRead(hdfsFname);
				client.HdfsDelete(hdfsFname);
			} catch (Exception e) {
				 //TODO Auto-generated catch block
				e.printStackTrace();
			}
			KVReaderWriterImpl reader1 = new KVReaderWriterImpl("data/ReasultatRead.txt");
			KVReaderWriterImpl writer1 = new KVReaderWriterImpl("data/Reasultfinale.txt");
			reader1.open("Read");
			writer1.open("Write");

			mr.reduce(reader1, writer1);
			 
			reader1.close();
			writer1.close();
			long t2 = System.currentTimeMillis();
			System.out.println("Fin du lancement du Job");
			System.out.println("time needed by JobLauncher in ms =" + (t2 - t1));

		} catch (RemoteException e) {
			e.printStackTrace();

		} catch (NotBoundException e) {
			e.printStackTrace();

		} catch (MalformedURLException e) {
			e.printStackTrace();
		}

	}

}
