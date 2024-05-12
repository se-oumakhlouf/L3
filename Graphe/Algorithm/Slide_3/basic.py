from dictionnaireadjacenceoriente import DictionnaireAdjacenceOriente

def ExtraireSommentLePlusProche(S, distances) :

    sommet = None
    distance_min = float('inf')
    for s in S :
        if distances[s] < distance_min :
            sommet = s
            distance_min = distances[s]
    if sommet != None :
        S.remove(sommet)
    return sommet

def Dijkstra(G, source) :
    
    a_traiter = G.sommets()
    dist = {sommet: float('inf') for sommet in G.sommets()}
    dist[source] = 0
    while a_traiter:
        u = ExtraireSommentLePlusProche(a_traiter, dist)
        if u is None:
            return dist
        for v in G.voisins(u):
            dist[v] = min(dist[v], dist[u] + G.poids_arete(u, v))
    return dist

def ProfondeurOriente(G, v, visites = None) :

    if visites is None :
        visites = {sommet: False for sommet in G.sommets()}
    resultat = []
    resultat.append(v)
    visites[v] = True
    for u in G.sucesseurs(v) :
        if not visites[u] :
            resultat += ProfondeurOriente(G, u, visites)
    return resultat

def ContientCycleOriente(G, v, status) :

    if status[v] == "en cours" :
        return True
    if status[v] == "fini" :
        return False
    status[v] = "en cours"
    for u in G.successeurs(v) :
        if ContientCycleOriente(G, u, status) :
            return True
    status[v] = "fini"
    return False

# renvoie un cylcle s'il existe, None sinon
def ContientCycleOrienteAux(G, v, status, parents) :

    status[v] = "en cours"
    for u in G.voisins(v) :
        if status[u] == "en cours" :
            return (v, u)
        if status[u] == "non visite" :
            parents[u] = v
            R = ContientCycleOrienteAux(G, u, status, parents)
            if R != False :
                return R
    status[v] = "fini"
    return False

def RenvoieCycle(G, v) :

    status = {sommet: None for sommet in G.sommets()}
    parents = {sommet: None for sommet in G.sommets()}
    for v in G.sommets() :
        if status[v] == None :
            R = ContientCycleOrienteAux(G, v, status, parents)
            if  R != False :
                break
#

def Kahn(G) :

    resultat = []
    sources = []
    degres = {sommet: 0 for sommet in G.sommets()}
    for v in G.sommets() :
        degres[v] = G.degre_entrant(v)
        if degres[v] == 0 :
            sources.append(v)
    
    while sources :
        u = sources.pop()
        resultat.append(u)
        for v in G.successeurs(u) :
            degres[v] -= 1
            if degres[v] == 0 :
                sources.append(v)

    return resultat

import copy
def FermetureTransitive(G) :

    F = copy.deepcopy(G)
    for u in F.sommets() :
        for v in ProfondeurOriente(F, u) :
            if u != v :
                F.ajouter_arc(u, v)

    return F