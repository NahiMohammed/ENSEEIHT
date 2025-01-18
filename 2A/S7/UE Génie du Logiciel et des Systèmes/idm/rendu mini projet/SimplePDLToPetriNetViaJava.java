package simplepdl.manip;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;
import java.io.IOException;
import java.util.Collections;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import petrinet.Arc;
import petrinet.ArcType;
import petrinet.PetriNet;
import petrinet.PetrinetFactory;
import petrinet.PetrinetPackage;
import petrinet.Place;
import petrinet.Transition;
import simplepdl.Process;
import simplepdl.ResourceUse;
import simplepdl.WorkDefinition;
import simplepdl.WorkSequence;
import simplepdl.WorkSequenceType;
import simplepdl.SimplepdlFactory;
import simplepdl.SimplepdlPackage;

public class SimplePDLToPetriNetViaJava {

	public static void main(String[] args) {

		// Charger le package SimplePDL afin de l'enregistrer dans le registre
		// d'Eclipse.
		SimplepdlPackage packageInstance = SimplepdlPackage.eINSTANCE;
		// Charger le package PetriNet afin de l'enregistrer dans le registre d'Eclipse.
		PetrinetPackage packageInstancePetriNet = PetrinetPackage.eINSTANCE;

		// Enregistrer l'extension ".xmi" comme devant Ãªtre ouverte Ã 
		// l'aide d'un objet "XMIResourceFactoryImpl"
		Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("xmi", new XMIResourceFactoryImpl());

		// Créer un objet resourceSetImpl qui contiendra une ressource EMF
		// le modèle SimplePDL
		ResourceSet resSetSimplePDL = new ResourceSetImpl();
		// le modèle PetriNet
		ResourceSet resSetPetriNet = new ResourceSetImpl();

		// charger le modèle SimplePDL
		URI modelURISimplePDL = URI.createURI("TransormationJAVA/Process1.xmi");
		Resource resourceSimplePDL = resSetSimplePDL.getResource(modelURISimplePDL, true);
		;
		// Définir la ressource pour le modèle PetriNet
		URI modelURIPetriNet = URI.createURI("TransormationJAVA/Petri1.xmi");
		Resource resourcePetriNet = resSetPetriNet.createResource(modelURIPetriNet);

		// La fabrique pour fabriquer les éléments de PetriNet
		PetrinetFactory PetriNetFactory = PetrinetFactory.eINSTANCE;

		// Recuperer le premier element du modele (element racine)
		Process process = (Process) resourceSimplePDL.getContents().get(0);

		// Créer un élément PetriNet
		PetriNet petrinet = PetriNetFactory.createPetriNet();
		petrinet.setName(process.getName());

		// Ajouter l'élément PetriNet dans le modèle
		resourcePetriNet.getContents().add(petrinet);

		Map<String, Place> places = new HashMap<String, Place>();
		Map<String, Transition> transitions = new HashMap<String, Transition>();
		
		for (Object o : process.getProcessElements()) {
			if (o instanceof WorkDefinition) {
				WorkDefinition wd = (WorkDefinition) o;
				createPetriNetElementsForWorkDefinition(wd, petrinet, places, transitions, PetriNetFactory);
			}
			if (o instanceof WorkSequence) {
				WorkSequence ws = (WorkSequence) o;
				createReadArc(ws, petrinet, places, transitions, PetriNetFactory);
			}
			if (o instanceof simplepdl.Resource) {
				simplepdl.Resource res = (simplepdl.Resource) o;
				createPetriNetElementsForResource(res, petrinet, places, transitions, PetriNetFactory);
			}
		}

		// Sauvegarder le PetriNet
		try {
			resourcePetriNet.save(Collections.EMPTY_MAP);
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	private static void createPetriNetElementsForResource(simplepdl.Resource res, PetriNet petrinet, Map<String, Place> places,
			Map<String, Transition> transitions, PetrinetFactory petriNetFactory) {
		Place resource = petriNetFactory.createPlace();

		resource.setName(res.getName());

		resource.setToken(res.getQuantity());

		petrinet.getPetrielements().add(resource);

		
		// Pour chaque utilisateur de la ressource, créer les arcs d'emprunt et de libération
	    for (ResourceUse utilisateur : res.getResourcesUsed()) {
	        // Arc d'emprunt
	        Arc borrowArc = petriNetFactory.createArc();
	        borrowArc.setLinkType(ArcType.NORMAL_ARC);
	        borrowArc.setPredecessor(resource);
	        // Lier à la transition appropriée pour l'utilisateur 
	        borrowArc.setSuccessor(transitions.get(utilisateur.getWorkdefinition().getName() + "_start" ));
	        borrowArc.setPrice(utilisateur.getOccurenceUsed());
	        petrinet.getPetrielements().add(borrowArc);

	        // Arc de libération
	        Arc releaseResourceArc = petriNetFactory.createArc();
	        releaseResourceArc.setPrice(utilisateur.getOccurenceUsed());
	        releaseResourceArc.setLinkType(ArcType.NORMAL_ARC);
	        releaseResourceArc.setPredecessor(transitions.get(utilisateur.getWorkdefinition().getName() + "_finish" ));
	        releaseResourceArc.setSuccessor(resource);
	        petrinet.getPetrielements().add(releaseResourceArc);
	    }

	}

	private static void createReadArc(WorkSequence ws, PetriNet petrinet, Map<String, Place> places,
			Map<String, Transition> transitions, PetrinetFactory PetriNetFactory) {
		WorkDefinition pre = ws.getPredecessor();
		WorkDefinition succ = ws.getSuccessor();

		Arc readArc = PetriNetFactory.createArc();
		readArc.setPrice(1);
		readArc.setLinkType(ArcType.READ_ARC);

		if (ws.getLinkType().equals(WorkSequenceType.START_TO_START)) {
			setPredecessorAndSuccessor(pre.getName() + "_started", succ.getName() + "_start", readArc, places,
					transitions);
		} else if (ws.getLinkType().equals(WorkSequenceType.START_TO_FINISH)) {
			setPredecessorAndSuccessor(pre.getName() + "_started", succ.getName() + "_finish", readArc, places,
					transitions);
		} else if (ws.getLinkType().equals(WorkSequenceType.FINISH_TO_START)) {
			setPredecessorAndSuccessor(pre.getName() + "_finished", succ.getName() + "_start", readArc, places,
					transitions);
		} else {
			setPredecessorAndSuccessor(pre.getName() + "_finished", succ.getName() + "_finish", readArc, places,
					transitions);
		}

		petrinet.getPetrielements().add(readArc);

	}

	private static void setPredecessorAndSuccessor(String predecessorName, String successorName, Arc arc,
			Map<String, Place> places, Map<String, Transition> transitions) {

		// Pour setPredecessor
		Place predecessorPlace = places.get(predecessorName);
		if (predecessorPlace != null) {
		    arc.setPredecessor(predecessorPlace);
		}

		// Pour setSuccessor
		Transition successorTransition = transitions.get(successorName);
		if (successorTransition != null) {
		    arc.setSuccessor(successorTransition);
		}

	}

	private static void createPetriNetElementsForWorkDefinition(WorkDefinition wd, PetriNet petrinet,
			Map<String, Place> places, Map<String, Transition> transitions, PetrinetFactory PetriNetFactory) {

		// Créez les places et les transitions associées à la WorkDefinition wd

		Place wd_ready = PetriNetFactory.createPlace();
		wd_ready.setName(wd.getName() + "_ready");
		wd_ready.setToken(1);
		petrinet.getPetrielements().add(wd_ready);

		Transition wd_start = PetriNetFactory.createTransition();
		wd_start.setName(wd.getName() + "_start");
		petrinet.getPetrielements().add(wd_start);

		Place wd_running = PetriNetFactory.createPlace();
		wd_running.setName(wd.getName() + "_running");
		wd_running.setToken(0);
		petrinet.getPetrielements().add(wd_running);

		Place wd_started = PetriNetFactory.createPlace();
		wd_started.setName(wd.getName() + "_started");
		wd_started.setToken(0);
		petrinet.getPetrielements().add(wd_started);

		Transition wd_finish = PetriNetFactory.createTransition();
		wd_finish.setName(wd.getName() + "_finish");
		petrinet.getPetrielements().add(wd_finish);

		Place wd_finished = PetriNetFactory.createPlace();
		wd_finished.setName(wd.getName() + "_finished");
		wd_finished.setToken(0);
		petrinet.getPetrielements().add(wd_finished);

		Arc arcReadyToStart = PetriNetFactory.createArc();
		arcReadyToStart.setPrice(1);
		arcReadyToStart.setLinkType(ArcType.NORMAL_ARC);
		arcReadyToStart.setPredecessor(wd_ready);
		arcReadyToStart.setSuccessor(wd_start);
		petrinet.getPetrielements().add(arcReadyToStart);

		Arc arcStartToStarted = PetriNetFactory.createArc();
		arcStartToStarted.setPrice(1);
		arcStartToStarted.setLinkType(ArcType.NORMAL_ARC);
		arcStartToStarted.setPredecessor(wd_start);
		arcStartToStarted.setSuccessor(wd_started);
		petrinet.getPetrielements().add(arcStartToStarted);

		Arc arcStarttoRunning = PetriNetFactory.createArc();
		arcStarttoRunning.setPrice(1);
		arcStarttoRunning.setLinkType(ArcType.NORMAL_ARC);
		arcStarttoRunning.setPredecessor(wd_start);
		arcStarttoRunning.setSuccessor(wd_running);
		petrinet.getPetrielements().add(arcStarttoRunning);

		Arc arcRunningToFinish = PetriNetFactory.createArc();
		arcRunningToFinish.setPrice(1);
		arcRunningToFinish.setLinkType(ArcType.NORMAL_ARC);
		arcRunningToFinish.setPredecessor(wd_running);
		arcRunningToFinish.setSuccessor(wd_finish);
		petrinet.getPetrielements().add(arcRunningToFinish);

		Arc arcFinishToFinished = PetriNetFactory.createArc();
		arcFinishToFinished.setPrice(1);
		arcFinishToFinished.setLinkType(ArcType.NORMAL_ARC);
		arcFinishToFinished.setPredecessor(wd_finish);
		arcFinishToFinished.setSuccessor(wd_finished);
		petrinet.getPetrielements().add(arcFinishToFinished);

		// Ajoutez ces éléments aux maps places et transitions
		places.put(wd_started.getName(), wd_started);
		places.put(wd_finished.getName(), wd_finished);
		transitions.put(wd_start.getName(), wd_start);
		transitions.put(wd_finish.getName(), wd_finish);

	}

}
