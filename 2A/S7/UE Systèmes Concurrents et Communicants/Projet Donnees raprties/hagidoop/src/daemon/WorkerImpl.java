package daemon;

import java.net.MalformedURLException;
import java.rmi.AlreadyBoundException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.List;

import interfaces.FileReaderWriter;
import interfaces.Map;
import interfaces.NetworkReaderWriter;

public class WorkerImpl extends UnicastRemoteObject implements Worker {

	protected WorkerImpl() throws RemoteException {
		super();

	}

	private static void usage() {
		System.out.println("Utilisation : java WorkerImpl port");
	}

	@Override
	public void runMap(Map m, FileReaderWriter reader, FileReaderWriter writer) throws RemoteException {
		System.out.println("Running map");
		reader.open("Read");
		writer.open("Write");

		m.map(reader, writer);
		// completionStatus.set(serverNumber, true);
		reader.close();
		writer.close();

	}

	public static void main(String args[]) throws MalformedURLException, RemoteException, AlreadyBoundException {
		try {
			// if (args.length < 1) {
			// usage();
			// System.exit(1);
			// }

			// int port = Integer.parseInt(args[0]);
			String hostname = "localhost";

			try {
				Registry registre = LocateRegistry.createRegistry(1001);

			} catch (Exception e) {
				e.printStackTrace();
			}
			String url = "//" + hostname + ":" + 1001 + "/Worker";

			Naming.bind(url, new WorkerImpl());
			System.out.println("Worker launched");

		} catch (MalformedURLException e) {
			e.printStackTrace();

		} catch (AlreadyBoundException e) {
			e.printStackTrace();

		} catch (RemoteException e) {
			e.printStackTrace();
		}

	}

}
