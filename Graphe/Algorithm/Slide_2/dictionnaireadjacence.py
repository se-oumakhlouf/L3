#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Implémentation d'un graphe non orienté à l'aide d'un dictionnaire : les clés
sont les sommets, et les valeurs sont les sommets adjacents à un sommet donné.
Les boucles sont autorisées. Les poids ne sont pas autorisés.

On utilise la représentation la plus simple : une arête {u, v} sera présente
deux fois dans le dictionnaire : v est dans l'ensemble des voisins de u, et u
est dans l'ensemble des voisins de v.
"""
from collections import defaultdict


class DictionnaireAdjacence(object):
    def __init__(self):
        """Initialise un graphe sans arêtes"""
        self.__dictionnaire = defaultdict(set)

    def ajouter_arete(self, u, v):
        """Ajoute une arête entre les sommets u et v, en créant les sommets
        manquants le cas échéant."""
        # ajoute u (resp. v) aux voisins de v (resp. u)
        self.__dictionnaire[u].add(v)
        self.__dictionnaire[v].add(u)

    def ajouter_aretes(self, iterable):
        """Ajoute toutes les arêtes de l'itérable donné au graphe. N'importe
        quel type d'itérable est acceptable, mais il faut qu'il ne contienne
        que des couples d'éléments (quel que soit le type du couple)."""
        for u, v in iterable:
            self.ajouter_arete(u, v)

    def ajouter_sommet(self, sommet):
        """Ajoute un sommet (de n'importe quel type hashable) au graphe."""
        self.__dictionnaire[sommet] = set()

    def ajouter_sommets(self, iterable):
        """Ajoute tous les sommets de l'itérable donné au graphe. N'importe
        quel type d'itérable est acceptable, mais il faut qu'il ne contienne
        que des éléments hashables."""
        for sommet in iterable:
            self.ajouter_sommet(sommet)

    def aretes(self):
        """Renvoie l'ensemble des arêtes du graphe. Une arête est représentée
        par un tuple (a, b) avec a <= b afin de permettre le renvoi de boucles.
        """
        return {
            (u, v) if u <= v else (v, u) for u in self.__dictionnaire
            for v in self.__dictionnaire[u]
        }

    def boucles(self):
        """Renvoie les boucles du graphe, c'est-à-dire les arêtes reliant un
        sommet à lui-même."""
        return {(u, u) for u in self.__dictionnaire if u in self.__dictionnaire[u]}

    def contient_arete(self, u, v):
        """Renvoie True si l'arête {u, v} existe, False sinon."""
        return u in self.__dictionnaire[v]  # ou v in self.__dictionnaire[u]

    def contient_sommet(self, u):
        """Renvoie True si le sommet u existe, False sinon."""
        return u in self.__dictionnaire

    def degre(self, sommet):
        """Renvoie le nombre de voisins du sommet ; s'il n'existe pas, provoque
        une erreur."""
        return len(self.__dictionnaire[sommet])

    def nombre_aretes(self):
        """Renvoie le nombre d'arêtes du graphe."""
        return len(self.aretes())

    def nombre_boucles(self):
        """Renvoie le nombre d'arêtes de la forme {u, u}."""
        return len(self.boucles())

    def nombre_sommets(self):
        """Renvoie le nombre de sommets du graphe."""
        return len(self.__dictionnaire)

    def retirer_arete(self, u, v):
        """Retire l'arête {u, v} si elle existe; provoque une erreur sinon."""
        self.__dictionnaire[u].remove(v)  # plante si u ou v n'existe pas
        self.__dictionnaire[v].remove(u)  # plante si u ou v n'existe pas

    def retirer_aretes(self, iterable):
        """Retire toutes les arêtes de l'itérable donné du graphe. N'importe
        quel type d'itérable est acceptable, mais il faut qu'il ne contienne
        que des couples d'éléments (quel que soit le type du couple)."""
        for u, v in iterable:
            self.retirer_arete(u, v)

    def retirer_sommet(self, sommet):
        """Efface le sommet du graphe, et retire toutes les arêtes qui lui
        sont incidentes."""
        self.__dictionnaire.pop(sommet)  # plante si le sommet n'existe pas
        # retirer le sommet des ensembles de voisins
        for u in self.__dictionnaire:
            self.__dictionnaire[u].discard(sommet)

    def retirer_sommets(self, iterable):
        """Efface les sommets de l'itérable donné du graphe, et retire toutes
        les arêtes incidentes à ces sommets."""
        for sommet in iterable:
            self.retirer_sommet(sommet)

    def sommets(self):
        """Renvoie l'ensemble des sommets du graphe."""
        return set(self.__dictionnaire)

    def sous_graphe_induit(self, iterable):
        """Renvoie le sous-graphe induit par l'itérable de sommets donné."""
        resultat = DictionnaireAdjacence()
        resultat.ajouter_sommets(iterable)
        for u, v in self.aretes():
            if resultat.contient_sommet(u) and resultat.contient_sommet(v):
                resultat.ajouter_arete(u, v)
        return resultat

    def voisins(self, sommet):
        """Renvoie l'ensemble des voisins du sommet donné."""
        return self.__dictionnaire[sommet]
