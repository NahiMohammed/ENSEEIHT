#!/usr/bin/env -P /usr/bin:/usr/local/bin python3 -B
# coding: utf-8

#
#  SpeechReco.py
#  SpeechReco version 1.0
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


class SpeechReco(metaclass=Singleton):
    def __init__(self):
        # inputs
        self.EcouteI = None

        # outputs
        self._recoO = None

    # outputs
    @property
    def recoO(self):
        return self._recoO

    @recoO.setter
    def recoO(self, value):
        self._recoO = value
        if self._recoO is not None:
            igs.output_set_string("reco", self._recoO)


