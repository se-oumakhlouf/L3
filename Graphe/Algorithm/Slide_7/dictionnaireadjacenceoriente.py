#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Implémentation d'un graphe orienté à l'aide d'un dictionnaire : les clés
sont les sommets, et les valeurs sont les successeurs du sommet donné sous la
forme d'un ensemble. Les boucles sont autorisées. Ni les arcs parallèles ni les
poids ne sont autorisés.

On utilise la représentation la plus simple -- et la moins efficace : une arête
{u, v} sera présente deux fois dans le dictionnaire : v est dans l'ensemble des
voisins de u, et u est dans l'ensemble des voisins de v.
"""
from collections import defaultdict


class DictionnaireAdjacenceOriente(object):
    def __init__(self):
        """Initialise un graphe sans arcs."""
        self.__dictionnaire = defaultdict(set)

    def ajouter_arc(self, u, v):
        """Ajoute un arc du sommet u vers le sommet v, en créant les sommets
        manquants le cas échéant."""
        # ajout de v parmi les successeurs de u
        self.__dictionnaire[u].add(v)

    def ajouter_arcs(self, iterable):
        """Ajoute tous les arcs de l'itérable donné au graphe. N'importe
        quel type d'itérable est acceptable, mais il faut qu'il ne contienne
        que des couples d'éléments (quel que soit le type du couple)."""
        for u, v in iterable:
            self.ajouter_arc(u, v)

    def ajouter_sommet(self, sommet):
        """Ajoute un sommet (de n'importe quel type hashable) au graphe."""
        self.__dictionnaire[sommet] = set()

    def ajouter_sommets(self, iterable):
        """Ajoute tous les sommets de l'itérable donné au graphe. N'importe
        quel type d'itérable est acceptable, mais il faut qu'il ne contienne
        que des éléments hashables."""
        for sommet in iterable:
            self.ajouter_sommet(sommet)

    def arcs(self):
        """Renvoie l'ensemble des arcs du graphe. Un arc est représenté par un
        tuple (a, b) afin de permettre le renvoi de boucles.
        """
        return {
            (u, v) for u in self.__dictionnaire for v in self.__dictionnaire[u]
        }

    def boucles(self):
        """Renvoie les boucles du graphe, c'est-à-dire les arcs reliant un
        sommet à lui-même."""
        return {(u, u) for u in self.__dictionnaire if u in self.__dictionnaire[u]}

    def contient_arc(self, u, v):
        """Renvoie True si l'arc (u, v) existe, False sinon."""
        return v in self.__dictionnaire[u]

    def contient_sommet(self, u):
        """Renvoie True si le sommet u existe, False sinon."""
        return u in self.__dictionnaire

    def degre(self, sommet):
        """Renvoie le nombre de voisins du sommet ; s'il n'existe pas, provoque
        une erreur."""
        return self.degre_entrant(sommet) + self.degre_sortant(sommet)

    def degre_entrant(self, sommet):
        """Renvoie le nombre de prédécesseurs du sommet ; s'il n'existe pas,
        provoque une erreur."""
        return sum(
            sommet in self.__dictionnaire[predecesseur]
            for predecesseur in self.__dictionnaire
        )

    def degre_sortant(self, sommet):
        """Renvoie le nombre de successeurs du sommet ; s'il n'existe pas,
        provoque une erreur."""
        return len(self.__dictionnaire[sommet])

    def nombre_arcs(self):
        """Renvoie le nombre d'arcs du graphe."""
        return sum(len(voisins) for voisins in self.__dictionnaire.values())

    def nombre_boucles(self):
        """Renvoie le nombre d'arêtes de la forme {u, u}."""
        return len(self.boucles())

    def nombre_sommets(self):
        """Renvoie le nombre de sommets du graphe."""
        return len(self.__dictionnaire)

    def predecesseurs(self, sommet):
        """Renvoie les prédécesseurs du sommet ; s'il n'existe pas, provoque une
        erreur."""
        return {
            predecesseur for predecesseur in self.__dictionnaire
            if sommet in self.__dictionnaire[predecesseur]
        }

    def retirer_arc(self, u, v):
        """Retire l'arc (u, v) s'il existe ; provoque une erreur sinon."""
        self.__dictionnaire[u].remove(v)  # plante si u ou v n'existe pas

    def retirer_arcs(self, iterable):
        """Retire tous les arcs de l'itérable donné du graphe. N'importe
        quel type d'itérable est acceptable, mais il faut qu'il ne contienne
        que des couples d'éléments (quel que soit le type du couple)."""
        for u, v in iterable:
            self.retirer_arc(u, v)

    def retirer_sommet(self, sommet):
        """Efface le sommet du graphe, et retire tous les arcs qui lui
        sont incidents."""
        # retrait du sommet et de ses successeurs
        self.__dictionnaire.pop(sommet)
        # retrait des arcs issus de ses prédécesseurs
        for u in self.__dictionnaire:
            self.__dictionnaire[u].discard(sommet)

    def retirer_sommets(self, iterable):
        """Efface les sommets de l'itérable donné du graphe, et retire toutes
        les arêtes incidentes à ces sommets."""
        for sommet in iterable:
            self.retirer_sommet(sommet)

    def sommets(self):
        """Renvoie l'ensemble des sommets du graphe."""
        return set(self.__dictionnaire.keys())

    def sous_graphe_induit(self, iterable):
        """Renvoie le sous-graphe induit par l'itérable de sommets donné."""
        retval = DictionnaireAdjacenceOriente()
        retval.ajouter_sommets(iterable)
        for u, v in self.arcs():
            if retval.contient_sommet(u) and retval.contient_sommet(v):
                retval.ajouter_arc(u, v)

        return retval

    def successeurs(self, sommet):
        """Renvoie les successeurs du sommet ; s'il n'existe pas, provoque une
        erreur."""
        return self.__dictionnaire[sommet]

    def voisins(self, sommet):
        """Renvoie l'ensemble des voisins du sommet donné."""
        return self.successeurs(sommet).union(self.predecesseurs(sommet))

    def __str__(self):
        """Formatage simple"""
        res = ["Graphe orienté avec %d sommets : %s"
               % (len(self.__dictionnaire), str(list(self.sommets())))]
        for k, v in self.__dictionnaire.items():
            for y in v:
                res.append("%s ---> %s" % (k, y))
        return "\n".join(res)

    def __repr__(self):
        return self.__str__()


def main():
    import doctest
    doctest.testmod()


if __name__ == "__main__":
    main()
