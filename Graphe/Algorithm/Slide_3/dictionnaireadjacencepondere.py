#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Implémentation d'un graphe non orienté pondéré à l'aide d'un dictionnaire :
les clés sont les sommets, et les valeurs sont les sommets adjacents à un
sommet donné avec un poids réel. Les boucles sont autorisées.

On utilise la représentation la plus simple -- et la moins efficace : une arête
{u, v} sera présente deux fois dans le dictionnaire : v est dans l'ensemble des
voisins de u, et u est dans l'ensemble des voisins de v.

"""
from collections import defaultdict


class DictionnaireAdjacencePondere(object):
    def __init__(self):
        """Initialise un graphe sans arêtes"""
        # chaque sommet possède un dictionnaire de voisins de la forme
        # {voisin : poids}
        self.__dictionnaire = defaultdict(lambda: defaultdict(float))

    def ajouter_arete(self, u, v, poids):
        """Ajoute une arête de poids donné entre les sommets u et v, en créant
        les sommets manquants le cas échéant."""
        # ajoute u (resp. v) aux voisins de v (resp. u) avec le poids
        # donné ; si l'arête était déjà présente, elle est écrasée
        self.__dictionnaire[u][v] = poids
        self.__dictionnaire[v][u] = poids

    def ajouter_aretes(self, iterable):
        """Ajoute toutes les arêtes de l'itérable donné au graphe. N'importe
        quel type d'itérable est acceptable, mais il faut qu'il ne contienne
        que des triples d'éléments (quel que soit le type du triple)."""
        for u, v, poids in iterable:
            self.ajouter_arete(u, v, poids)

    def ajouter_sommet(self, sommet):
        """Ajoute un sommet (de n'importe quel type hashable) au graphe."""
        self.__dictionnaire[sommet] = defaultdict(float)

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
            (u, v, poids) if u <= v else (v, u, poids) for u in self.__dictionnaire
            for v, poids in self.__dictionnaire[u].items()
        }

    def aretes_incidentes(self, sommet):
        """Renvoie l'ensemble des arêtes incidentes à un sommet donné."""
        return {
            (sommet, voisin, poids) if sommet <= voisin else (voisin, sommet, poids)
            for voisin, poids in self.__dictionnaire[sommet].items()
        }

    def boucles(self):
        """Renvoie les boucles du graphe, c'est-à-dire les arêtes reliant un
        sommet à lui-même."""
        retval = set()
        for u in self.__dictionnaire:
            if u in self.__dictionnaire[u]:
                retval.add((u, u, self.__dictionnaire[u][u]))

        return retval

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
        # attention à la division par 2 (chaque arête étant comptée deux fois) !
        return sum(len(voisins) for voisins in self.__dictionnaire.values()) // 2

    def nombre_boucles(self):
        """Renvoie le nombre d'arêtes de la forme {u, u}."""
        return len(self.boucles())

    def nombre_sommets(self):
        """Renvoie le nombre de sommets du graphe."""
        return len(self.__dictionnaire)

    def poids_arete(self, u, v):
        """Renvoie le poids de l'arête {u, v}, None si elle n'existe pas."""
        if v in self.__dictionnaire[u]:
            return self.__dictionnaire[u][v]

    def retirer_arete(self, u, v):
        """Retire l'arête {u, v} si elle existe ; provoque une erreur sinon."""
        self.__dictionnaire[u].pop(v)  # plante si v n'existe pas
        self.__dictionnaire[v].pop(u)  # plante si u n'existe pas

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
        for u in self.__dictionnaire:
            if sommet in self.__dictionnaire[u]:
                self.__dictionnaire[u].pop(sommet)

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
        resultat = DictionnaireAdjacencePondere()
        resultat.ajouter_sommets(iterable)
        for u, v, poids in self.aretes():
            if resultat.contient_sommet(u) and resultat.contient_sommet(v):
                resultat.ajouter_arete(u, v, poids)
        return resultat

    def voisins(self, sommet):
        """Renvoie les voisins du sommet donné."""
        return self.__dictionnaire[sommet]
