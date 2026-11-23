// TamaÃ±os explÃ­citos de los recursos y capacidades de los vectores.
int[] cant_nv3_plataformas = {6, 8, 27};
int[] cant_nv3_escaleras = {8, 8, 5};
int[] cant_nv3_cintas = {0, 3, 0};
int[] cant_nv3_pisosFuego = {1, 2, 2};
int parTotalCartasAnimadas = 0;
char[] caracterAuxiliar = new char[1];

// Los archivos y el texto partido se cuentan al recorrer sus cadenas.
int contarCadenas(String[] cadenas) {
  int cantidad = 0;
  if (cadenas != null) {
    for (String cadena : cadenas) cantidad++;
  }
  return cantidad;
}

char leerCaracter(String texto, int posicion) {
  texto.getChars(posicion, posicion + 1, caracterAuxiliar, 0);
  return caracterAuxiliar[0];
}
