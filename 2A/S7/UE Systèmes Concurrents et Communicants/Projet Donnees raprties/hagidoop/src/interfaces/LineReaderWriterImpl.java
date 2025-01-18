package interfaces;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class LineReaderWriterImpl implements FileReaderWriter {

	private String nameF;
	private int index = 0;
	protected FileReader fichierLecture;
	protected BufferedReader buffer;
	protected FileWriter fichierEcriture;

	// Gestion des threads :
	protected boolean oLect = false;
	protected boolean oEcriture = false;

	public LineReaderWriterImpl(String Name) {
		this.nameF = Name;
	}

	@Override
	public KV read() {
		String line = null;
		if (oLect) {
			try {
				line = buffer.readLine();
				this.index++;

			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			System.err.println("Message erreur de READ");
		}

		if (line != null) {
			return new KV("" + index, line);
		} else {
			return null;
		}
	}

	@Override
	public void write(KV record) {
		if (!oEcriture) {
			System.err.println("Opértation interdite");
			return;
		}
		try {
			fichierEcriture.write(record.v + "\n");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void open(String mode) {
		try {
			File fichier = new File(this.nameF);


			File parentDirs = fichier.getParentFile();
            if (parentDirs != null) {
                parentDirs.mkdirs();
            } 

			if (OpenMode.valueOf(mode) == OpenMode.Read) {
				System.out.println("Ouverture du fichier " + nameF + " en mode lecture -> ");
				oLect = true;
				// On ouvre le fichie en lecture
				fichier.setReadable(true);
				fichierLecture = new FileReader(fichier);
				buffer = new BufferedReader(fichierLecture);

			} else {
				System.out.println("Ouverture du fichier " + nameF + " en mode ecriture.");
				oEcriture = true;
				fichier.setWritable(true);
				fichierEcriture = new FileWriter(fichier, true);
			}
		} catch (Exception e) {
			System.err.println("Impossible d'ouvrir le fichier.");
			e.printStackTrace();
		}

	}

	@Override
	public void close() {
		try {
			if (oEcriture) {
				fichierEcriture.close();
				oEcriture = false;
			}
			if (oLect) {
				// fichierLecture.close();
				oLect = false;
				buffer.close();
				index = 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public long getIndex() {
		return index;
	}

	@Override
	public String getFname() {
		return nameF;
	}

	@Override
	public void setFname(String fname) {
		if (!oLect && !oEcriture) {
			this.nameF = fname;
		} else {
			System.err.println("Fermer le fichier avant de modifier son nom.");
		}

	}

	public static FileReaderWriter build(String string) {
		// TODO Auto-generated method stub
		return null;
	}

}
