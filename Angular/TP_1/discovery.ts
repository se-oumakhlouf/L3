// Exo 0 

interface Personne {
    name: string;
    age: number;
    permis: boolean;
}

let p1: Personne = {name: "Selym",age: 22, permis: true};
console.log("Exo 0 : ");
console.log(p1);


// Exo 1

function pourToiPourMoi(name?: string) : string {
    if (name) {
        return "Un pour " + name + ", un pour moi";
    }
    return "Un pour toi, un pour moi";
}

console.log("Exo 1 : ");
console.log(pourToiPourMoi('toto'));
console.log(pourToiPourMoi());


// Exo 2

function tellBob(phrase?: string) : string {
    if (!phrase || phrase === " ") {
        return "Ok, si tu veux";
    }
    else if (phrase[phrase.length - 1 ] === "?") {
        return "Bien sur";
    }
    else if (phrase.toUpperCase() === phrase) {
        return "Du calme";
    }
    else {
        return "Peu m'importe";
    }
}

console.log("Exo 2 : ");
console.log(tellBob("Tu vas bien ?"));
console.log(tellBob("AHHHHH"));
console.log(tellBob());
console.log(tellBob("Ceci Est un test ? de tellBob."));


// Exo 3

function isPangram(phrase: string) : boolean {
    const alphabet = "abcdefghijklmnopqrstuvwxyz";

    for (let letter of alphabet) {
        if (phrase.search(letter) === -1) {
            return false;
        }
    }
    return true;
}

const pangram = "portez ce vieux whisky au juge blond qui fume ABAU9UZHD";
console.log("Exo 3 : ");
console.log("Test isPangram sur la phase : \n" + pangram);
console.log(isPangram(pangram));


// Exo 4

enum allergieEnum {
    oeuf = 1,
    cacachuete = 2,
    fruit_de_mer = 4,
    fraise = 8,
    tomate = 16,
    chocolat = 32,
    pollen = 64,
    chats = 128
};

class Patient {

    private score: number;

    constructor(score: number) {
        this.score = score;
    }

    isAllergicTo(allergie: string): boolean {;
        return this.listAllergies().includes(allergie);
    }
    
    listAllergies(): string[] {
        const allergicTo: string[] = [];
        for (let i = 0; i < 8; i++) {
            if (this.score & (1 << i)) {
                allergicTo.push(allergieEnum[1 << i]);
            }
        }
        return allergicTo;
    }
}

const patient: Patient = new Patient(34);
console.log("Exo 4 : ");
console.log(patient.isAllergicTo("chats")); //  expected false
console.log(patient.isAllergicTo("cacachuete")); // expected true
console.log(patient.listAllergies()); // expected ["cacachuete", "chocolat"]