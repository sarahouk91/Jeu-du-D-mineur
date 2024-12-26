
int cote;
int bandeau;
int colonnes;
int lignes;

int etat;
//int etat_bloc; on met en commentaire parce que etat bloc spécifie seuelement un bloc


float start;
float time;
int minesrestantes;  //= 100; //je définis un nombre de mines
//variables à 2 dimensions 
int [][] paves; //2 crochets : 2 dimensions
boolean [][] bombes;
int [][]nb_bombes;

//final pour indiquer qu'il s'agit d'une valeur qui ne sera pas modifiée
final int init = 0;
final int started = 1;
final int over = 2;

final int bloc = 0;
final int empty = 1;
final int flag = 2;




void settings() {
  cote=20;
  bandeau=50;
  colonnes=30;
  lignes=16;
  etat = init;
  size((30*20) , ((16*20)+bandeau));
}
void setup () {
  init();
}

void draw () {
  background(192);
  display ();
  drawTime();
  drawScore();
  if(etat == started)
    time = (millis()-start) / 1000;
}

void drawBloc (int x, int y, int w, int h) {
  pushMatrix ();
  translate (x*cote, (y*cote)+bandeau);
  noStroke();
  //la partie blanche extérieure
  fill(255);
  rect(0,2,2,16);
  rect(0,0,18,2);
  rect(0,18,1,1);
  rect(18,0,1,1);
  //la partie grise au centre du bloc
  fill(180);
  square(2,2,16);

  //la partie ombrée des cotés du bloc
  fill(110);
  rect(1,18,17,2);
  rect(0,19,1,1);
  rect(18,1,2,19);
  rect(19,0,1,1);
  popMatrix();
}

void drawFlag (int x, int y) {
  pushMatrix ();
  translate (x*cote, (y*cote)+bandeau);
  //le baton pour la tenir
  rect(10,4,1,9);
  //la base du drapeau
  noStroke();
  fill(0);
  rect(4,15,13,2);
  rect(6,13,9,2);
  //le drapeau en rouge donc (255,0,0)
  noStroke();
  fill(255,0,0);
  square(7,5,3);
  rect(5,6,2,1);
  square(9,4,1);
  square(9,8,1);
  popMatrix();
}

void drawBomb (int x, int y) {
  pushMatrix ();
  translate (x*cote, (y*cote)+bandeau);
  noStroke();
  fill(0);
  //le centre de la bombe en noir
  square(8,6,5);
  square(6,8,5);
  square(10,8,5);
  square(8,10,5);
  square(7,7,7);
  //les pixels sur les extremités 
  square(5,5,1);
  square(6,6,1);
  square(15,5,1);
  square(14,6,1);
  square(5,15,1);
  square(6,14,1);
  square(15,15,1);
  square(14,14,1);

  //le baton vertical et horizontale ( le +)
  rect(4,10,13,1);
  rect(10,4,1,13);

  //la partie centrale blanche de la bombe
  fill(255);
  rect(8,8,2,4);
  rect(7,9,4,2);
  popMatrix();
}

void drawHappyFace () {
  float xSmiley = (width/2)-(cote/2);
  float ySmiley = (bandeau/2)-(cote/2);
  pushMatrix ();
  translate (xSmiley, ySmiley);
  //le contour de la tête en noir (0) et le fond en jaune (250,250,200)
  stroke(0);
  fill(255,255,0);
  ellipse(10,10,14,14);
  //les yeux en noir
  fill(0);
  ellipse(7,7,2,2);
  ellipse(13,7,2,2);
  //la bouche qui est donc un arc de cercle de couleur noir
  stroke(0);
  noFill();
  arc(10,13,8,4,PI/4,3*PI/4);
  popMatrix();

}

void drawSadFace () {
  float xSmiley = (width/2)-10;
  float ySmiley = (bandeau/2)-10;
  pushMatrix ();
  translate (xSmiley, ySmiley);
  //le contour de la tête en noir (0) et le fond en jaune (250,250,200)
  stroke(0);
  fill(255,255,0);
  ellipse(10,10,14,14);
  //les yeux en forme de croix en noir
  fill(0);
  line(6,6,8,8);
  line(8,6,6,8);
  line(12,6,14,8);
  line(14,6,12,8);
  //la bouche en forme d'arc de cercle à l'envers de couleur noir
  stroke(0);
  noFill();
  arc(10,16,8,8,5*PI/4,7*PI/4);
  popMatrix();
}

void mouseClicked (){
  //blocX ou blocY pour avoir de façon plus globale la position du bloc dans la grille
  int blocX, blocY;
  blocX = mouseX / cote;
  blocY = (mouseY - bandeau) / cote;
  //qd on clic sur la zone en gris foncée en dessous du bandeau
  if( etat == init && mouseY>bandeau){
    etat = started;
    start = millis();
  }
  else if (etat == started) {
    if (mouseX >= (colonnes / 2) * cote && mouseX <= ((colonnes / 2) + 1) * cote && mouseY >= (lignes / 2) * cote + bandeau && mouseY <= (lignes / 2) * cote + bandeau) {
    //else if(mouseX>=(width/2)-(cote/2) && mouseX <= (width/2)+(cote/2) && mouseY >= (bandeau/2) - (cote/2) && mouseY <= (bandeau/2) +(cote/2)){
      etat = over;
    }
  
    //quand mouseX est dans le smiley happy face c'est à dire est compris dans l'encadrement : de coordonnées (width/2-10,width/2+10) / bandeau/2 -10
    //quand on clic sur le bloc du smiley
    if (mouseX >= (width/2) - (cote/2) && mouseX <= width/2 + (cote/2) && mouseY >= ((bandeau/2))-(cote/2)  && mouseY <= bandeau/2 + cote/2){
      etat=init;
      init();
    }
    //qd on clic sur le bloc de la bombe 
    int etat_bloc = paves[blocX][blocY];
    //si on clic gauche sur un bloc et qu'il y a une bombe l'état passe à over
    if(mouseButton == LEFT){
      if(bombes[blocX][blocY] == true){
        etat = over;
      }
      //si on clic gauche et qu'il y a un bloc on affiche rien
      else if(etat_bloc == bloc){
        paves[blocX][blocY] = empty;
      }
    }
    //si on clic droit donc qu'on met un drapeu on décrémente le nombre de mines restantes
    else if ( mouseButton == RIGHT){
      if(etat_bloc == bloc){
        paves[blocX][blocY] = flag;
        minesrestantes--;
      }
     //si on clic droit et qu'il y a un drapeau et qu'on l'enève dcp on se retrouve en bloc et donc on réincrémente le nombre de bombes restantes 
      else if ( etat_bloc == flag){
        paves[blocX][blocY] = bloc;
        minesrestantes++;
      }
    } 
  }
  else if (etat==over){
    //qd on clic sur le bloc du smiley alors que l'on a perdu
    if (mouseX >= (width/2) - (cote/2) && mouseX <= width/2 + (cote/2) && mouseY >= ((bandeau/2))-(cote/2)  && mouseY <= bandeau/2 + cote/2){
      etat=init;
      init();
    }
  }
  //si on est au lancement du jeu dans la zone des blocs
  if (etat == init && mouseY > bandeau) {
    etat = started;
    start = millis();
  } 
}

void drawTime (){  
  //variable de type PFont pour afficher le chronomètre
PFont chronomètre;
  //créer la police de caractère dans la base de donnée, en taille 32
  chronomètre = createFont("DSEG7Classic-Bold.ttf", + 32);
  textFont(chronomètre);
  //rectangle noir en haut à droite de la fenêtre
  fill(0);
  rect(width-80,0, 80,40);
  //afficher " 888 "
  textAlign ( CENTER,CENTER);
  fill(90, 10, 10);
  if(etat == init)
    text("888", width-40,20);
  else {
    String timeavec3chiffres = nf(int (time),3);
    //on recommence à calculer le temps avec la fonction millis()
    fill(255,0,0);
    //textSize(28);
    text(timeavec3chiffres, width-40,20);
  }
}

void drawScore (){
    //rectangle noir en haut à gauche pour afficher le nombre de mines 
    fill(0);
    rect(0,0,80,40);
    
    PFont mines;
     mines = createFont("DSEG7Classic-Bold.ttf", + 32);
    textFont(mines);
    //on précise la police choisie en la rendant active avec "textFont(nom de la variable qui indique la police)"
    textFont(mines);
    //taille du texte : textSize
    //aligner le texte au centre du rectangle
    textAlign(CENTER,CENTER);
    //afficher le texte 888 en rouge
    fill (90, 10, 10);
    if(etat == init)
      text("888",40,20);
    else {
      //affihcher le nombre de mines avec 3 chiffres et 0 à gauche
      String minesrestantesavec3chiffres = nf ( minesrestantes,3);
      
      //afficher le nombres de mines restantes
      fill(255, 0, 0);
      textAlign(CENTER,CENTER);
      text(minesrestantesavec3chiffres,40,20);
    }
    
} 
void display () {
  background(192);
  PFont nombres;
  nombres = createFont("mine-sweeper.ttf",12); // taille 12 environ ça doit être bien
  textFont(nombres);
  if (etat == init || etat == started){
    drawHappyFace();
  } 
  else if ( etat == over){
    drawSadFace();
  } 
  //afficher la grille de 30*16 blocs
 for ( int i = 0; i < colonnes; i++){
   for ( int j = 0; j < lignes; j++){
     float x = i*cote; //coordonnées x du bloc
     float y = bandeau + j * cote; //coordonnées y du bloc
     if (paves[i][j] == bloc || paves[i][j] == flag){
     drawBloc(i,j,cote,cote); //dessiner les blocs de largeur cote
     }
     if(paves [i][j] == flag){
       drawFlag(i,j);
     }
     //afficher le nombre de bombes autour de la case si etat = empty et nombre de bombes est nul
     if ( paves[i][j] == empty && nb_bombes [i][j] > 0){
       textAlign(CENTER,CENTER);
       text(nb_bombes[i][j], x + (cote/2), y + (cote/2));
     }
     //verrifier si il y a une bombe dans la case et afficher la bombe
     if (etat == over && bombes[i][j]){ //parce qu'on a intialiser bombe à vrai dans init()
       drawBomb (i,j);
     }
     else if( paves[i][j] == empty){
       int nombredebombesautour = nb_bombes[i][j];
       if(nombredebombesautour != 0){ //quand c'est pas 0 c'est donc les autres chiffres qui ont chacun leur couleur
         if (nombredebombesautour == 1){
           fill (0, 35, 245);
         }
         else if ( nombredebombesautour == 2){
           fill(55, 125, 35);
         }
         else if ( nombredebombesautour == 3){
           fill(235, 50, 35);
         }
         else if( nombredebombesautour == 4){
           fill(120, 25, 120);
         }
         else if(nombredebombesautour==5){
           fill(115, 20, 10);
         }
         else if(nombredebombesautour==6){
           fill(55, 125, 125);
         }
         else { //sinon en noir 
           fill(0,0,0);
         } 
         
          textAlign (CENTER,CENTER); //centrer le nombre dans la case
          text(nombredebombesautour,x + (cote / 2), y + (cote / 2));
         }
       }
     }
   }
 }
 

void init(){
  minesrestantes = 100;
  //etat_bloc = bloc;
  paves = new int[colonnes][lignes]; //en 2 dimensions donc i : colonnes et j : lignes 
  bombes = new boolean[colonnes][lignes]; //new:crée un nouveau tableau 
  
  //initialisation de tous les blocs dans l'état bloc : 
  for (int i=0; i < colonnes; i++){ //pour les colonnes donc pour i
    for ( int j=0; j < lignes; j++){// pour les lignes donc pour j
      paves[i][j] = bloc; //les blocs = bloc
    }
  }
  bombes = new boolean [colonnes][lignes];
  for (int i=0; i < colonnes; i++){
    for ( int j=0; j < lignes; j++){
      bombes[i][j] = false; //initialiser à de base faux 
    }
  }
  //une centaine de bombes aléatoirement
  for (int k=0 ; k < 100 ; k++){
    int randomC = int (random(colonnes)); //un chiffre en entier aléatoirement pr colonnes
    int randomL = int (random(lignes));//same pour lignes
    bombes[randomC][randomL] = true; //changer la valeur des casesx à true.
  }
  nb_bombes= new int [colonnes][lignes];
  //initier toutes les valeurs de la bombe à 0
  for (int i=0 ; i < colonnes; i++){
    for (int j=0; j < lignes; j++){
      nb_bombes [i][j] = 0;
    }
  }
  //calculer toutes les valeurs du tableau à l'aide du tableau nb_bombes
  for (int i=0; i < colonnes; i++){
    for (int j=0; j < lignes; j++){
      //les 8 cases autour de la case sur laquelle on est
      for (int l = -1; l <= 1; l++){ //les cases d'avant et après en abscisse ( c'est un intervalle : -1<x<1)
        for (int m = -1; m <= 1; m++){ //les cases d'avant et d'après en ordonnée
        //ccase intérieur de la grille : 
        int C = i + l; //décalage horizontal
        int L = j + m; //décalage vertical
        if ( C >=0 && C < colonnes && L >= 0 && L < lignes){ //si C et L sont positifs et qu'ils sont plus petits que les limites de la grille colonnes et lignes
        //si il y a une bombe : 
        if (bombes[C][L]){
          nb_bombes[i][j]++; //on incrémente pour avoir le nombre de bombes qu'il y a dans le voisinage de la case en question
        }
        }
        }
      }
    }
  }

}
