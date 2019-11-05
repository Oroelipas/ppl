%{
#include <stdio.h>
#include <stdlib.h> //para hacer exit()
extern int yylex();
extern int yylineno;
void yyerror(const char *s);
FILE *fSaR;
%}
/*
%glr-parser ESTO DE CAMBIAR DE TIPO DE PARSER NO CREO QUE SEA BUENA IDEA
%expect-rr 6
*/
%union{
  char *str;
  char caracter;
  double doble;
  int entero;
}

%start ty_desc_algoritmo

%token TK_PARENTESIS_INICIAL
%token TK_PARENTESIS_FINAL
%token TK_ASIGNACION
%token TK_PUNTOYCOMA
%token TK_SEPARADOR
%token TK_SUBRANGO
%token TK_TIPO_VAR
%token TK_ENTONCES
%token TK_SINOSI
%token TK_FIN_ARRAY

%token TK_PR_ACCION
%token TK_PR_ALGORITMO
%token TK_PR_BOOLEANO
%token TK_PR_CADENA
%token TK_PR_CARACTER
%token TK_PR_CONST
%token TK_PR_CONTINUAR
%token TK_PR_DE
%token TK_PR_DEV
%token TK_PR_ENT
%token TK_PR_ENTERO
%token TK_PR_ES
%token TK_PR_FACCION
%token TK_PR_FALGORITMO
%token TK_PR_FCONST
%token TK_PR_FFUNCION
%token TK_PR_FMIENTRAS
%token TK_PR_FPARA
%token TK_PR_FSI
%token TK_PR_FTIPO
%token TK_PR_FTUPLA
%token TK_PR_FUNCION
%token TK_PR_FVAR
%token TK_PR_HACER
%token TK_PR_HASTA
%token TK_PR_MIENTRAS
%token TK_PR_PARA
%token TK_PR_REAL
%token TK_PR_SAL
%token TK_PR_SI
%token TK_PR_TABLA
%token TK_PR_TIPO
%token TK_PR_TUPLA
%token TK_PR_VAR
%token TK_COMENTARIO
/* TK_CADENA DE MOMENTO EN LA GRAMATICA NO SE USA*/
%token <str> TK_CADENA
%token <caracter> TK_CARACTER
%token <str> TK_IDENTIFICADOR
%token <doble> TK_ENTERO
%token <doble> TK_REAL
%token <entero> TK_BOOLEANO


%precedence TK_NADA_PRIORITARIO
/*no todos los TK_OP_RELACIONAL pueden usarse para boolenaos, solo = y <>.  PERO NO <,>,=>,=<*/
%left TK_PR_O
%left TK_PR_Y
/*%nonassoc para no permitir 3<4<5*/
%nonassoc TK_IGUAL
%nonassoc <str> TK_OP_RELACIONAL 
%nonassoc TK_PR_NO
%left TK_MAS TK_MENOS
%left TK_MULT TK_DIV TK_DIV_ENT TK_MOD
%left TK_MENOS_U
/*TK_INICIO_ARRAY es left para cuando estamos en un estado a[b].[c] para que se reduzca a[b] y no siga leyendo [c]*/
%left TK_INICIO_ARRAY
%left TK_PUNTO
%left TK_PR_REF
%precedence TK_MUY_PRIORITARIO


%type <str> ty_desc_algoritmo
%type <str> ty_cabecera_alg
%type <str> ty_bloque_alg
%type <str> ty_decl_globales
%type <str> ty_decl_a_f
%type <str> ty_bloque
%type <str> ty_declaraciones
%type <str> ty_decl_tipo
%type <str> ty_decl_cte
%type <str> ty_decl_var
%type <str> ty_lista_d_tipo
%type <str> ty_d_tipo
%type <str> ty_expresion_t
%type <str> ty_lista_campos
%type <str> ty_tipo_base
%type <str> ty_lista_d_cte
%type <str> ty_lista_d_var
%type <str> ty_lista_id
%type <str> ty_decl_ent_sal
%type <str> ty_decl_ent
%type <str> ty_decl_sal
%type <str> ty_expresion
%type <str> ty_exp_a
%type <str> ty_exp_b
%type <str> ty_operando
%type <str> ty_instrucciones
%type <str> ty_instruccion
%type <str> ty_asignacion
%type <str> ty_alternativa
%type <str> ty_lista_opciones
%type <str> ty_iteracion
%type <str> ty_it_cota_exp
%type <str> ty_it_cota_fija
%type <str> ty_accion_d
%type <str> ty_funcion_d
%type <str> ty_a_cabecera
%type <str> ty_f_cabecera
%type <str> ty_d_par_form
%type <str> ty_d_p_form
%type <str> ty_accion_ll
%type <str> ty_funcion_ll
%type <str> ty_l_ll


%%

ty_desc_algoritmo:
/* aqui en la gramatica de fitxi hay un punto despues de falgoritmo que hemos quitado porque en los ejemplos no esta*/
    TK_PR_ALGORITMO TK_IDENTIFICADOR TK_PUNTOYCOMA ty_cabecera_alg ty_bloque_alg TK_PR_FALGORITMO {fprintf(fSaR,"REDUCE ty_desc_algoritmo: TK_PR_ALGORITMO TK_IDENTIFICADOR TK_PUNTOYCOMA ty_cabecera_alg ty_bloque_alg TK_PR_FALGORITMO\n");}
    ;

ty_cabecera_alg:
    ty_decl_globales ty_decl_a_f ty_decl_ent_sal TK_COMENTARIO {fprintf(fSaR,"REDUCE ty_cabecera_alg: ty_decl_globales ty_decl_a_f ty_decl_ent_sal TK_COMENTARIO\n");}
    ;

ty_bloque_alg:
    ty_bloque TK_COMENTARIO {fprintf(fSaR,"REDUCE ty_bloque_alg: ty_bloque TK_COMENTARIO\n");}
    ;

ty_decl_globales:
      ty_decl_tipo  ty_decl_globales {fprintf(fSaR,"REDUCE ty_decl_globales: ty_decl_tipo  ty_decl_globales\n");}
    | ty_decl_cte ty_decl_globales {fprintf(fSaR,"REDUCE ty_decl_globales: ty_decl_cte ty_decl_globales\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_decl_globales: vacio\n");}
    ;

ty_decl_a_f:
      ty_accion_d  ty_decl_a_f {fprintf(fSaR,"REDUCE ty_decl_a_f: ty_accion_d  ty_decl_a_f\n");}
    | ty_funcion_d ty_decl_a_f {fprintf(fSaR,"REDUCE ty_decl_a_f: ty_funcion_d ty_decl_a_f \n");}
    | /*vacio*/ {fprintf(fSaR,"REDUCE ty_decl_a_f: vacio\n");}
    ;

ty_bloque:
    ty_declaraciones ty_instrucciones {fprintf(fSaR,"REDUCE ty_bloque: ty_declaraciones ty_instrucciones\n");}
    ;

ty_declaraciones:
      ty_decl_tipo ty_declaraciones {fprintf(fSaR,"REDUCE ty_declaraciones: ty_decl_tipo  ty_declaraciones\n");}
    | ty_decl_cte  ty_declaraciones {fprintf(fSaR,"REDUCE ty_declaraciones: ty_decl_cte ty_declaraciones \n");}
    | ty_decl_var  ty_declaraciones {fprintf(fSaR,"REDUCE ty_declaraciones: ty_decl_var   ty_declaraciones\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_declaraciones: vacio\n");}
    ;

ty_decl_tipo:
    TK_PR_TIPO ty_lista_d_tipo TK_PR_FTIPO TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_decl_tipo: TK_PR_TIPO ty_lista_d_tipo TK_PR_FTIPO TK_PUNTOYCOMA\n");}
    ;

ty_decl_cte:
    TK_PR_CONST ty_lista_d_cte TK_PR_FCONST TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_decl_cte: TK_PR_CONST ty_lista_d_cte TK_PR_FCONST TK_PUNTOYCOMA\n");}
    ;

ty_decl_var:
    TK_PR_VAR ty_lista_d_var TK_PR_FVAR TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_decl_var: TK_PR_VAR ty_lista_d_var TK_PR_FVAR TK_PUNTOYCOMA\n");}//los programas de fitxi no tienen ;
    ;

ty_lista_d_tipo:
      TK_IDENTIFICADOR TK_IGUAL ty_d_tipo TK_PUNTOYCOMA ty_lista_d_tipo {fprintf(fSaR,"REDUCE ty_lista_d_tipo: TK_IDENTIFICADOR TK_IGUAL ty_d_tipo TK_PUNTOYCOMA ty_lista_d_tipo\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_lista_d_tipo: vacio\n");}
    ;

ty_d_tipo:
      TK_PR_TUPLA ty_lista_campos TK_PR_FTUPLA {fprintf(fSaR,"REDUCE ty_d_tipo: TK_PR_TUPLA ty_lista_campos TK_PR_FTUPLA\n");}
    | TK_PR_TABLA TK_INICIO_ARRAY ty_expresion_t TK_SUBRANGO ty_expresion_t TK_FIN_ARRAY TK_PR_DE ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_tipo: TK_PR_TABLA TK_INICIO_ARRAY ty_expresion_t TK_SUBRANGO ty_expresion_t TK_FIN_ARRAY TK_PR_DE ty_d_tipo\n");}
    | TK_IDENTIFICADOR {fprintf(fSaR,"REDUCE ty_d_tipo: TK_IDENTIFICADOR\n");}
    | ty_expresion_t TK_SUBRANGO ty_expresion_t {fprintf(fSaR,"REDUCE ty_d_tipo: ty_expresion_t TK_SUBRANGO ty_expresion_t\n");}
    | TK_PR_REF ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_tipo: TK_PR_REF ty_d_tipo\n");}
    | ty_tipo_base {fprintf(fSaR,"REDUCE ty_d_tipo: ty_tipo_base\n");}
    ;

ty_expresion_t:
      ty_expresion {fprintf(fSaR,"REDUCE ty_expresion_t: ty_expresion\n");}
    | TK_CARACTER{fprintf(fSaR,"REDUCE ty_expresion_t: TK_CARACTER\n");}
    /*AQUI NO HAY CADENAS?????? ENTONCES NO SE PUEDE HACER a:= "hola"   */
    ;

ty_lista_campos:
    TK_IDENTIFICADOR TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_campos {fprintf(fSaR,"REDUCE ty_lista_campos: TK_IDENTIFICADOR TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_campos\n");}
    |/*vacio*/{{fprintf(fSaR,"REDUCE ty_lista_campos: vacio\n");}}
    ;

ty_tipo_base:
    /*BOOLEANO NO ESTABA ORIGINALMENTE EN LA DOCUMENTACION*/
     TK_PR_BOOLEANO {fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_BOOLEANO\n");}
    |TK_PR_ENTERO {fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_ENTERO\n");}
    |TK_PR_CARACTER {fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_CARACTER\n");}
    |TK_PR_REAL {fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_REAL\n");}
    |TK_PR_CADENA {fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_CADENA\n");}
    ;

ty_lista_d_cte:/*En el enunciado pone "literal" pero se referira a ty_tipo_base*/
    TK_IDENTIFICADOR TK_IGUAL ty_tipo_base TK_PUNTOYCOMA ty_lista_d_cte{fprintf(fSaR,"REDUCE ty_lista_d_cte: TK_IDENTIFICADOR TK_IGUAL ty_tipo_base TK_PUNTOYCOMA ty_lista_d_cte\n");}
    |/*vacio*/{fprintf(fSaR,"REDUCE ty_lista_d_cte: vacio\n");}
    ;

ty_lista_d_var:
      ty_lista_id TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_d_var {fprintf(fSaR,"REDUCE ty_lista_d_var: ty_lista_id TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_d_var\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_lista_d_var: vacio\n");}
    ;

ty_lista_id:
      TK_IDENTIFICADOR TK_SEPARADOR ty_lista_id {fprintf(fSaR,"REDUCE ty_lista_id: TK_IDENTIFICADOR TK_SEPARADOR ty_lista_id\n");}
    | TK_IDENTIFICADOR {fprintf(fSaR,"REDUCE ty_lista_id: TK_IDENTIFICADOR\n");}
    ;

ty_decl_ent_sal:
      ty_decl_ent {fprintf(fSaR,"REDUCE ty_decl_ent_sal: ty_decl_ent\n");}
    | ty_decl_ent ty_decl_sal {fprintf(fSaR,"REDUCE ty_decl_ent_sal: ty_decl_ent ty_decl_sal\n");}
    | ty_decl_sal {fprintf(fSaR,"REDUCE ty_decl_ent_sal: ty_decl_sal\n");}
    ;

ty_decl_ent:
    TK_PR_ENT ty_lista_d_var {fprintf(fSaR,"REDUCE ty_decl_ent: TK_PR_ENT ty_lista_d_var\n");}
    ;

ty_decl_sal:
    TK_PR_SAL ty_lista_d_var {fprintf(fSaR,"REDUCE ty_decl_sal: TK_PR_SAL ty_lista_d_var\n");}
    ;

ty_exp_a:
      ty_exp_a TK_MAS ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MAS ty_exp_a\n");}
    | ty_exp_a TK_MENOS ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MENOS ty_exp_a\n");}
    | ty_exp_a TK_MULT ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MULT ty_exp_a\n");}
    | ty_exp_a TK_DIV ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a:  ty_exp_a TK_DIV ty_exp_a \n");}
    | ty_exp_a TK_MOD ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MOD ty_exp_a\n");}
    | ty_exp_a TK_DIV_ENT ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_DIV_ENT ty_exp_a\n");}
    | TK_PARENTESIS_INICIAL ty_exp_a TK_PARENTESIS_FINAL {fprintf(fSaR,"REDUCE ty_exp_a: TK_PARENTESIS_INICIAL ty_exp_a TK_PARENTESIS_FINAL\n");}
    | ty_operando {fprintf(fSaR,"REDUCE ty_exp_a: ty_operando\n");}
    | TK_ENTERO {fprintf(fSaR,"REDUCE ty_exp_a: TK_ENTERO\n");}
    | TK_REAL {fprintf(fSaR,"REDUCE ty_exp_a: TK_REAL\n");}
    | TK_MENOS ty_exp_a %prec TK_MENOS_U {fprintf(fSaR,"REDUCE ty_exp_a: TK_MENOS ty_exp_a\n");}
    ;

/*
ESTO ES PARA ELIMINAR LOS S/R
(TAMBIEN MOLARIA QUE MAS, MENOS, MULT, DIV.... ESTUVIESEN JUNTOS COMO ESTOS)
NO SABEMOS LA FORMA DE QUE AL HACER ESTO ty_op_relacional TAMBIEN SEA NONASOC
ty_op_relacional:
      TK_OP_RELACIONAL {}
    | TK_IGUAL {}
    ;
*/
    
ty_exp_b:
      ty_exp_b TK_PR_Y ty_exp_b {fprintf(fSaR,"REDUCE ty_exp_b: ty_exp_b TK_PR_Y ty_exp_b\n");}/*AQUI IGUAL SE PUEDEN DEFINIR OP_LOGICO: CUYOS VALORES SEAN Y,O*/
    | ty_exp_b TK_PR_O ty_exp_b {fprintf(fSaR,"REDUCE ty_exp_b: ty_exp_b TK_PR_O ty_exp_b\n");}
    | TK_PR_NO ty_exp_b /*%prec TK_MUY_PRIORITARIO*/{fprintf(fSaR,"REDUCE ty_exp_b: TK_PR_NO ty_exp_b\n");}
    | TK_BOOLEANO {fprintf(fSaR,"REDUCE ty_exp_b: TK_BOOLEANO\n");}
    | ty_expresion TK_OP_RELACIONAL ty_expresion {fprintf(fSaR,"REDUCE ty_exp_b: ty_expresion TK_OP_RELACIONAL ty_expresion\n");}
    | ty_expresion TK_IGUAL ty_expresion {fprintf(fSaR,"REDUCE ty_exp_b: ty_expresion TK_IGUAL ty_expresion\n");}
    | TK_PARENTESIS_INICIAL ty_exp_b TK_PARENTESIS_FINAL {fprintf(fSaR,"REDUCE ty_exp_b: TK_PARENTESIS_INICIAL ty_exp_b TK_PARENTESIS_FINAL\n");}
    ;

ty_expresion:
      ty_exp_a {fprintf(fSaR,"REDUCE ty_expresion: ty_exp_a\n");}
    | ty_exp_b %prec TK_NADA_PRIORITARIO{fprintf(fSaR,"REDUCE ty_expresion: ty_exp_b\n");} /*ESTO NO TIENE QUE FUNCIONAR ASI!!!!!*/
    | ty_funcion_ll {fprintf(fSaR,"REDUCE ty_expresion: ty_funcion_ll\n");}
    ;


ty_operando:
    /*AQUI EN EL CONFLICTO SUPONGO QUE HABRA QUE HACER UN SHIFT POR PURA ASOCIATIVIDAD, PARA REDUCIR LA PILA.
    ADEMAS ES EL MODO DE ACCEDER A LAS VARIABLES: SI TIENES variable1.variable2[variable3] PRIMERO HABRA QUE IR DE FUERA HACIA ADENTRO Y REDUCIR variable1.variable2 A UNA SOLA VARIABLE (variable12) PARA LUEGO ACCEDER A ESA VARIABLE variable12[variable3]*/
      TK_IDENTIFICADOR {fprintf(fSaR,"REDUCE ty_operando: TK_IDENTIFICADOR\n");}
    | ty_operando TK_PUNTO ty_operando {fprintf(fSaR,"REDUCE ty_operando: ty_operando TK_PUNTO ty_operando\n");}
    | ty_operando TK_INICIO_ARRAY ty_expresion TK_FIN_ARRAY {fprintf(fSaR,"REDUCE ty_operando: ty_operando TK_INICIO_ARRAY ty_expresion TK_FIN_ARRAY\n");}
    | ty_operando TK_PR_REF {fprintf(fSaR,"REDUCE ty_operando: ty_operando TK_PR_REF\n");}
    ;

ty_instrucciones:
      ty_instruccion TK_PUNTOYCOMA ty_instrucciones {fprintf(fSaR,"REDUCE ty_instrucciones: ty_instruccion TK_PUNTOYCOMA ty_instrucciones\n");}
    | ty_instruccion {fprintf(fSaR,"REDUCE ty_instrucciones: ty_instruccion\n");}
    ;

ty_instruccion:
      TK_PR_CONTINUAR {fprintf(fSaR,"REDUCE ty_instruccion: TK_PR_CONTINUAR\n");}
    | ty_asignacion {fprintf(fSaR,"REDUCE ty_instruccion: ty_asignacion\n");}
    | ty_alternativa {fprintf(fSaR,"REDUCE ty_instruccion: ty_alternativa\n");}
    | ty_iteracion {fprintf(fSaR,"REDUCE ty_instruccion: ty_iteracion\n");}
    | ty_accion_ll {fprintf(fSaR,"REDUCE ty_instruccion: ty_accion_ll\n");}
    ;

ty_asignacion:
    /*Hemos puesto ty_expresion_t en vex de ty_expresion para poder hacer a = 'a'*/
    /*AUN NO SE PUEDEN HACER ASIGNACIONES CON CADENAS a = "hola"     */
    ty_operando TK_ASIGNACION ty_expresion_t {fprintf(fSaR,"REDUCE ty_asignacion:ty_operando TK_ASIGNACION ty_expresion_t\n");}
    ;

ty_alternativa:
    TK_PR_SI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones TK_PR_FSI {fprintf(fSaR,"REDUCE ty_alternativa: TK_PR_SI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones TK_PR_FSI\n");}
    ;

ty_lista_opciones:
     TK_SINOSI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones {fprintf(fSaR,"REDUCE TK_SINOSI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_lista_opciones: vacio\n");}
    ;

ty_iteracion:
      ty_it_cota_fija {fprintf(fSaR,"REDUCE ty_iteracion: ty_it_cota_fija\n");}
    | ty_it_cota_exp {fprintf(fSaR,"REDUCE ty_iteracion: ty_it_cota_exp\n");}
    ;

ty_it_cota_exp:
    TK_PR_MIENTRAS ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FMIENTRAS {fprintf(fSaR,"REDUCE ty_it_cota_exp:  TK_PR_MIENTRAS ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FMIENTRAS\n");}
    ;

ty_it_cota_fija:
    TK_PR_PARA TK_IDENTIFICADOR TK_ASIGNACION ty_expresion TK_PR_HASTA ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FPARA {fprintf(fSaR,"REDUCE ty_it_cota_fija: TK_PR_PARA TK_IDENTIFICADOR TK_ASIGNACION ty_expresion TK_PR_HASTA ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FPARA\n");}
    ;

ty_accion_d:
    TK_PR_ACCION ty_a_cabecera ty_bloque TK_PR_FACCION {fprintf(fSaR,"REDUCE ty_accion_d: TK_PR_ACCION ty_a_cabecera ty_bloque TK_PR_FACCION\n");}
    ;

ty_funcion_d:
    TK_PR_FUNCION ty_f_cabecera ty_bloque TK_PR_DEV ty_expresion TK_PR_FFUNCION {fprintf(fSaR,"REDUCE ty_funcion_d: TK_PR_FUNCION ty_f_cabecera ty_bloque TK_PR_DEV ty_expresion TK_PR_FFUNCION\n");}
    ;

ty_a_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_d_par_form TK_PARENTESIS_FINAL TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_a_cabecera: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_d_par_form TK_PARENTESIS_FINAL TK_PUNTOYCOMA\n");}
    ;

 ty_f_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_lista_d_var TK_PARENTESIS_FINAL TK_PR_DEV ty_d_tipo TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_f_cabecera: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_lista_d_var TK_PARENTESIS_FINAL TK_PR_DEV ty_d_tipo TK_PUNTOYCOMA\n");}
    ;

ty_d_par_form:
    ty_d_p_form TK_PUNTOYCOMA ty_d_par_form {fprintf(fSaR,"REDUCE ty_d_par_form: ty_d_p_form TK_PUNTOYCOMA ty_d_par_form\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_d_par_form: vacio\n");}
    ;

ty_d_p_form:
      TK_PR_ENT ty_lista_id TK_TIPO_VAR ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_p_form: TK_PR_ENT ty_lista_id TK_TIPO_VAR ty_d_tipo\n");}
    | TK_PR_SAL ty_lista_id TK_TIPO_VAR ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_p_form: TK_PR_SAL ty_lista_id TK_TIPO_VAR ty_d_tipo\n");}
    | TK_PR_ES  ty_lista_id TK_TIPO_VAR ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_p_form: TK_PR_ES  ty_lista_id TK_TIPO_VAR ty_d_tip\n");}
    ;

ty_accion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {fprintf(fSaR,"REDUCE ty_accion_ll: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL\n");}
    ;

ty_funcion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {fprintf(fSaR,"REDUCE ty_funcion_ll: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL\n");}
    ;

ty_l_ll:
      ty_expresion TK_SEPARADOR ty_l_ll {fprintf(fSaR,"REDUCE ty_l_ll: ty_expresion TK_SEPARADOR ty_l_ll\n");}
    | ty_expresion {fprintf(fSaR,"REDUCE ty_l_ll: ty_expresion\n");}
    ;


%%
FILE *fTablaSimbolos;

int main (int argc, char *argv[]) {
    //checkear numero de parametros
    if(argc != 2){
        printf("Uso del compilador: ./a.out <NombreDelPprogama>\n");
        exit(1);
    }
    
    //redirigir el archivo del programa a la entrada estandar
    FILE *fPrograma = freopen(argv[1], "r", stdin);
    if(fPrograma == 0){
        printf("fichero %s no encontrado\n", argv[1]);
        exit(1);
    }
    
    //Abrir el fichero con con SHIFT y los REDUCE
    fSaR = fopen("ShiftsAndReduces.txt", "w");
    if (fSaR == NULL){
        printf("Error opening file ShiftsAndReduces.txt\n");
        exit(1);
    }
    
    //Abrir el fichero con con la tabla de simbolos
    fTablaSimbolos = fopen("tablaSimbolos.txt", "w");
    if (fTablaSimbolos == NULL){
        printf("Error opening file tablaSimbolos.txt\n");
        exit(1);
    }

  yyparse();

}

void yyerror(const char *s) {
	printf("Error en lina %i: %s\nRevise ShiftsAndReduces.txt\n",yylineno, s);
}










/*

// DOCUMENTACION EN: http://dinosaur.compilertools.net/bison/

 */
