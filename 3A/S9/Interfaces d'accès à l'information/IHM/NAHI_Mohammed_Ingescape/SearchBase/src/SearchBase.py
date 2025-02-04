#!/usr/bin/env -P /usr/bin:/usr/local/bin python3 -B
# coding: utf-8

#
#  SearchBase.py
#  SearchBase version 1.0
#  Created by Ingenuity i/o on 2025/02/01
#
# "no description"
#
import ingescape as igs


class Singleton(type):
    _instances = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class SearchBase(metaclass=Singleton):
    def __init__(self):
        # inputs
        self.departI = None
        self.arriveeI = None

        # outputs
        self._resultTravelAvionO = None
        self._resultTravelTrainO = None
        self._resultTravelBusO = None

    # outputs
    @property
    def resultTravelAvionO(self):
        return self._resultTravelAvionO

    @resultTravelAvionO.setter
    def resultTravelAvionO(self, value):
        self._resultTravelAvionO = value
        if self._resultTravelAvionO is not None:
            igs.output_set_string("resultTravelAvion", self._resultTravelAvionO)
    @property
    def resultTravelTrainO(self):
        return self._resultTravelTrainO

    @resultTravelTrainO.setter
    def resultTravelTrainO(self, value):
        self._resultTravelTrainO = value
        if self._resultTravelTrainO is not None:
            igs.output_set_string("resultTravelTrain", self._resultTravelTrainO)
    @property
    def resultTravelBusO(self):
        return self._resultTravelBusO

    @resultTravelBusO.setter
    def resultTravelBusO(self, value):
        self._resultTravelBusO = value
        if self._resultTravelBusO is not None:
            igs.output_set_string("resultTravelBus", self._resultTravelBusO)


