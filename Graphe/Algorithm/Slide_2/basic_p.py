from dictionnaireadjacencepondere import DictionnaireAdjacencePondere
import heapq

#TD3 Exo1
G = DictionnaireAdjacencePondere()
G.ajouter_sommets([chr(ord('A')+i) for i in range(7)])
G.ajouter_aretes([('A', 'B', 4), ('A', 'D', 3), ('A', 'E', 1), ('A', 'F', 8)])
G.ajouter_aretes([('B', 'C', 7), ('B', 'D', 2), ('B', 'E', 3)])
G.ajouter_aretes([('C', 'E', 8), ('C', 'F', 5), ('C', 'G', 4)])
G.ajouter_aretes([('D', 'E', 6)])
G.ajouter_aretes([('E', 'F', 9), ('E', 'G', 6)])
G.ajouter_aretes([('F', 'G', 2)])

print('les sommets de G sont', G.sommets())
print('les voisins de A sont', G.voisins('A'), '\n')
print('le poids de l\'arete {A, B} est', G.poids_arete('A', 'B'), '\n')


def StockerAretesValides(G, u, S, hors_arbre):
    for v in G.voisins(u):
        if hors_arbre[v]:
            S.append((u, v, G.poids_arete(u, v)))


hors_arbre = {sommet: True for sommet in G.sommets()}
hors_arbre['A'] = False
S = []
StockerAretesValides(G, 'A', S, hors_arbre)
print('Les arêtes valides sont :', S)


def ExtraireAreteSure(S, hors_arbre):
    while S:
        p, u, v = heapq.heappop(S) # S.extract_min()
        if hors_arbre[u] != hors_arbre[v]:
            return u, v, p
    return None, None, None


def Prim(G, depart):
    arbre = DictionnaireAdjacencePondere()
    arbre.ajouter_sommet(depart)
    hors_arbre = {sommet: True for sommet in G.sommets()}
    hors_arbre[depart] = False
    candidates = []
    StockerAretesValides(G, depart, candidates, hors_arbre)
    while True:
        u, v, p = ExtraireAreteSure(candidates, hors_arbre)
        if u is None:
            return arbre
        if hors_arbre[v]:
            u, v = v, u
        arbre.ajouter_arete(u, v, p)
        hors_arbre[u] = False
        StockerAretesValides(G, u, candidates, hors_arbre)

