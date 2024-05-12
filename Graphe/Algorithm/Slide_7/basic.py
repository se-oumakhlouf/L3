from dictionnaireadjacenceoriente import DictionnaireAdjacenceOriente

def FiboRec(val, n) :
    if val[n] == - 1 :
        val[n] = FiboRec(val, n - 1) + FiboRec(val, n - 2)
    return val[n]

def FiboMieux(n) :
    val = [-1] * (n + 1)
    val[0] = 0
    val[1] = 1
    return FiboRec(val, n)

def FiboStockage(n) :
    if n <= 1 :
        return n
    F = [0] *(n + 1)
    F[1] = 1
    for i in range(2, n + 1):
        F[i] = F[i - 1] + F[i - 2]
    return F[n]

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

def PlusCourtsCheminsDAG(G, s) : 
    dist = [float('inf')] * len(G)
    dist[s] = 0
    for u in Kahn(G) :
        for w in G.successeurs(u) :
            dist[w] = min(dist[w], dist[u] + G.poids_arete(u, w))
    return dist

def DecoupeNaive(n, prix) :
    if n <= 1 :
        return prix[n]
    meilleur = prix[n]
    for i in range(1, n) :
        meilleur = max(meilleur, prix[i] + DecoupeNaive(n - i, prix))

def DecoupeOptiProgDyn(n, prix) :
    profits = prix
    for k in range (2, n + 1) :
        for i in range (1, k) :
            profits[k] = max(profits[k], prix[i] + profits[k - i])
    return profits[n]

def SubsetSumRec(M, S, u) :
    if M == 0 & S != None :
        return None
    if M == 0 & S == None :
        return 0
    for v in S :
        sol_partielle = SubsetSumRec(M - v, S - {v}, u)
        if sol_partielle != None :
            return sol_partielle + v
    return None

def SubsetSumProgDyn(M, S) :
    sol = [None] * (M + 1)
    for v in range (0, M + 1) :
        if v in S :
            sol[v] = v
        else :
            for w in S : 
                if sol[v - w] != None :
                    sol[v] = v + sol(v - w)
    return sol[M]