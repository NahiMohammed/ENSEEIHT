#!/usr/bin/env -P /usr/bin:/usr/local/bin python3 -B
# coding: utf-8

#
#  interpreter.py
#  interpreter version 1.0
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


class Interpreter(metaclass=Singleton):
    def __init__(self):
        # inputs
        self.stringRecoI = None

        # outputs
        self._titleWhiteBoardO = None
        self._DepartO = None
        self._ArriveeO = None
        self._finiO = None

    # outputs
    @property
    def titleWhiteBoardO(self):
        return self._titleWhiteBoardO

    @titleWhiteBoardO.setter
    def titleWhiteBoardO(self, value):
        self._titleWhiteBoardO = value
        if self._titleWhiteBoardO is not None:
            igs.output_set_string("titleWhiteBoard", self._titleWhiteBoardO)
    @property
    def DepartO(self):
        return self._DepartO

    @DepartO.setter
    def DepartO(self, value):
        self._DepartO = value
        if self._DepartO is not None:
            igs.output_set_string("Depart", self._DepartO)
    @property
    def ArriveeO(self):
        return self._ArriveeO

    @ArriveeO.setter
    def ArriveeO(self, value):
        self._ArriveeO = value
        if self._ArriveeO is not None:
            igs.output_set_string("Arrivee", self._ArriveeO)
    @property
    def finiO(self):
        return self._finiO

    @finiO.setter
    def finiO(self, value):
        self._finiO = value
        if self._finiO is not None:
            igs.output_set_bool("fini", self._finiO)


