package daemon;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

import interfaces.FileReaderWriter;
import interfaces.Map;
import interfaces.NetworkReaderWriter;

public interface Worker extends Remote {
	public void runMap (Map m, FileReaderWriter reader, FileReaderWriter writer) throws RemoteException;

}
