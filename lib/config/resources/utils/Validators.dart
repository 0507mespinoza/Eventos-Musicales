class Validators {

  static String? validateEmpty (String? value){
     if (value == null || value.isEmpty){
        return "El campo esta vacio";
      }
      return null;
  }
}