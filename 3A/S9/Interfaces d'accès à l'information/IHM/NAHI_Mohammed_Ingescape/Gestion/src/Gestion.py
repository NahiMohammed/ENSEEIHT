#!/usr/bin/env -P /usr/bin:/usr/local/bin python3 -B
# coding: utf-8

#
#  Gestion.py
#  Gestion version 1.0
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


class Gestion(metaclass=Singleton):
    def __init__(self):
        # inputs
        self.resultTravelAvionI = None
        self.resultTravelTrainI = None
        self.resultTravelBusI = None

        # outputs
        self._result_voyageO = None
        self._finiO = None

    # outputs
    @property
    def result_voyageO(self):
        return self._result_voyageO

    @result_voyageO.setter
    def result_voyageO(self, value):
        self._result_voyageO = value
        if self._result_voyageO is not None:
            igs.output_set_string("result_voyage", self._result_voyageO)
    @property
    def finiO(self):
        return self._finiO

    @finiO.setter
    def finiO(self, value):
        self._finiO = value
        if self._finiO is not None:
            igs.output_set_bool("fini", self._finiO)


