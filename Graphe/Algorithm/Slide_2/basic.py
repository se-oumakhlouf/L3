from dictionnaireadjacence import DictionnaireAdjacence

#TD2 Exo1
G = DictionnaireAdjacence()
G.ajouter_sommets([chr(ord('A')+i) for i in range(13)])
G.ajouter_aretes([('A','B'), ('A','F'), ('A','G')])
G.ajouter_aretes([('C','A')])
G.ajouter_aretes([('D','F')])
G.ajouter_aretes([('E','D')])
G.ajouter_aretes([('F','E')])
G.ajouter_aretes([('G','C'), ('G','E'), ('G','J')])
G.ajouter_aretes([('H','G'), ('H','I')])
G.ajouter_aretes([('I','H')])
G.ajouter_aretes([('J','K'), ('J','L'), ('J','M')])
G.ajouter_aretes([('L','G'), ('L','M')])
G.ajouter_aretes([('M','L')])

print('les sommets de G sont', G.sommets())
print('les voisins de A sont', G.voisins('A'), '\n')


def profondeur(G, depart):
    resultat = []
    visites = {sommet: False for sommet in G.sommets()}
    a_traiter = [depart]
    parents = {sommet: False for sommet in G.sommets()}
    Arbre = DictionnaireAdjacence()

    while a_traiter:
        u = a_traiter.pop()
        if not visites[u]:
            resultat.append(u)
            visites[u] = True
            for v in G.voisins(u):
                if not visites[v]:
                    a_traiter.append(v)
                    parents[v] = u
                if parents[v] != False:
                    Arbre.ajouter_aretes([(v, u)])

    #return resultat
    return Arbre

Arbre = profondeur(G, 'A')
print('Arbre.aretes() (profondeur):\n', Arbre.aretes(), '\n')


def largeur(G, depart):
    resultat = []
    visites = {sommet: False for sommet in G.sommets()}
    a_traiter = [depart]
    parents = {sommet: False for sommet in G.sommets()}
    Arbre = DictionnaireAdjacence()

    while a_traiter:
        u = a_traiter.pop()
        if not visites[u]:
            resultat.append(u)
            visites[u] = True
            for v in G.voisins(u):
                if not visites[v]:
                    a_traiter.insert(0, v)
                if not parents[v]:
                    parents[v] = u
                if parents[v] != False:
                    Arbre.ajouter_aretes([(v, u)])

    #return resultat
    return Arbre

Arbre = largeur(G, 'A')
print('Arbre.aretes() (largeur):\n', Arbre.aretes(), '\n')


def composantes_connexes(G):
    resultat = []
    visites = {sommet: False for sommet in G.sommets()}
    for sommet in G.sommets():
        if not visites[sommet]:
            composante = profondeur(G, sommet)
            for sommet in composante.sommets():
                visites[sommet] = True
            resultat.append(composante)

    return resultat

composantes = composantes_connexes(G)
print('composantes connexes:')
for composante in composantes:
    print(composante.aretes())


def est_biparti(G):
    # -1 : non visité
    bipartition = {sommet: -1 for sommet in G.sommets()}
    depart = next(iter(G.sommets()))
    a_traiter = [depart]
    bipartition[depart] = False
    while a_traiter:
        u = a_traiter.pop()
        for v in G.voisins(u):
            if bipartition[v] == -1:
                bipartition[v] = not bipartition[u]
                a_traiter.append(v)
            elif bipartition[v] == bipartition[u]:
                return False
    return True