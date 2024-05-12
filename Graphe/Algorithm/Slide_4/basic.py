from dictionnaireadjacenceorientepondere import DictionnaireAdjacenceOrientePondere

def ProfondeurDates(G, v, dates, instant) :

    dates[v] = 0    # marque le début de l'exploration
    for u in G.successeurs(v) :
        if dates[u] == None :
            ProfondeurDates(G, u, dates, instant)
    dates[v] = instant    # marque la fin de l'exploration
    instant += 1

#
def ProfondeurPileFin(G):
    visites = {sommet: False for sommet in G.sommets()}
    pile_fin = []

    def dfs(v):
        visites[v] = True
        for u in G.voisins(v):
            if not visites[u]:
                dfs(u)
        pile_fin.append(v)

    for v in G.sommets():
        if not visites[v]:
            dfs(v)

    return pile_fin

def ParcoursInverse(G, v, visites):
    CFC = []
    pile = [v]

    while pile:
        v = pile.pop()
        if not visites[v]:
            visites[v] = True
            CFC.append(v)
            pile.extend(G.voisins_inverse(v))  # voisins dans le graphe transposé

    return CFC
#

def KosarajuSharir(G) :

    CFC = []
    a_traiter = ProfondeurPileFin(G)
    visites = {sommet : False for sommet in G.sommets()}
    while a_traiter : 
        v = a_traiter.pop()
        if not visites[v] :
            CFC.append(ParcoursInverse(G, v, visites))
    return CFC

def BellmanFord(G, s) :

    distances = {sommet : float('inf') for sommet in G.sommets()}
    distances[s] = 0
    for i in range(1, len(G.sommets()) - 1) :
        for (u, v, poids) in G.arcs() :
            distances[v] = min(distances[v], distances[u] + poids)

    for (u, v, poids) in G.arcs() : # vérifier la présence d'un cycle négatif
        if distances[v] > distances[u] + poids :
            return None
    return distances

def FloydWarshall(G) : 

    n = len(G.sommets())
    dist = [[float('inf') for _ in range(n)] for _ in range(n)]
    for i in range (0, n) :
        dist[i][i] = 0
    for (u, v, p) in G.arcs() :
        dist[u][v] = p
    for k in range (0, n) :
        for i in range (0, n) :
            for j in range (0, n) :
                dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])
    return dist


# Flot
def MettreAJourResiduel(G, Gf, S, f):

    cf = dict()
    for (u, v) in S:
        if (u, v) in G.arcs():
            cf[(u, v)] = G.poids_arc(u, v) - f[(u, v)]
            cf[(v, u)] = f[(u, v)]
        else:
            cf[(u, v)] = f[(v, u)]
            cf[(v, u)] = G.poids_arc(v, u) - f[(v, u)]

        if cf[(u, v)] > 0:
            Gf.ajouter_arc(u, v, cf[(u, v)])
        else:
            Gf.supprimer_arc(u, v)

        if cf[(v, u)] > 0:
            Gf.ajouter_arc(v, u, cf[(v, u)])
        else:
            Gf.supprimer_arc(v, u)