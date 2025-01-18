
class ProtectionProxy:

    def __init__(self, objet, *interdits):
        self.__recepteur = objet
        self.__interdites = set(interdits)
        print('self.__interdites =', self.__interdites)
        print(dir(self.__class__))
        '''
        Ceci est nécessaire pour que ces opérations fonctionnent sur le
        ProtectionProxy
        '''
        for f in ('__str__', '__repr__', '__getitem__', '__len__'):
        # for f in dir(objet):
            print('f =', f)
            if f not in ('__class__', '__getattribute__', '__getattr__'):
                if f not in self.__interdites:
                    setattr(self.__class__, f, getattr(objet, f))
        # self.__class__.__str__ = self.recepteur.__str__

    def __getattr__(self, name):
        print('ProtectionProxy.__getattr__: ', name)
        if name in self.__interdites:
            raise AttributeError('Forbidden call: ' + name)
        else:
            print('ProtectionProxy: looking for', name)
            return getattr(self.__recepteur, name)

#    def __getattribute__(self, name):
#        print('__getattribute__: ', name)
#        return super().__getattribute__(name)

    ''' Ne marche pas !
    def __getattribute__(self, name):
        print('__getattribute__: ', name)
        if name in super().__getattribute__('_' + 'ProtectionProxy' + '__interdites'):
            raise AttributeError('Forbidden call: ' + name)
        return super().__getattribute__('_ProtectionProxy__recepteur').__getattribute__(name)
    '''

    ''' Trace : quand est-ce qu'un attribut est accédé.
    def __getattribute__(self, name):
        print('=== ProtectionProxy.' '__getattribute__: ', name)
        return super().__getattribute__(name)
    '''

def exemple_list():
    l = [2, 3, 5, 7]
    p = ProtectionProxy(l, 'append', 'remove', 'insert', '__iadd__')

    l.append(11);
    l.remove(3)

    print('dir(l) =', dir(l))
    print('dir(p) =', dir(p))

    print('p =', p)

    print('taille')
    print(len(p))
    print(p[0])

    try:
        p.append(11)
        print('11 ajouté :', p)
    except Exception as e:
        print(e)

    try:
        p.remove(2)
        print('2 removed :', p)
    except Exception as e:
        print(e)

    try:
        print('l =', l)
        l.insert(0, -1)
        print('-1 inserted at 0 :', l)
        p.insert(0, -1)
        print('-1 inserted at 0 :', p)
    except Exception as e:
        print(e)

    try:
        l += [5]
        print('l =', l)
        print('Trying +=')
        p += [5]
        print('p =', p)
        print('id(p) =', id(p))
        print('id(l) =', id(l))
        print('type(p) =', type(p))
    except Exception as e:
        print(e)


    print('p =', p)

    print(isinstance(p, list))
    print(isinstance(l, list))

if __name__ == '__main__':
    exemple_list()
