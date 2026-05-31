# Instrucciones Finales - Proyecto Flutter Shopping App

## Estado Actual
Se han implementado la mayoría de las pantallas y funcionalidades del proyecto. Solo quedan pasos finales para completar.

## Pasos Finales

### 1. Descargar Dependencias
```bash
cd "c:\Users\aleja\Desktop\michaelespinozac1 - copia"
flutter pub get
```

### 2. Verificar Pantalla de Registro (pantalla_registro.dart)
La pantalla de registro debe incluir:
- Campo de usuario
- Campo de contraseña
- Campo de repetir contraseña
- Selector de Trato (Sr./Sra.)
- Campo de edad
- Campo de lugar de nacimiento
- Opciones para tomar foto / cargar imagen
- Checkbox de términos y condiciones

### 3. Usuarios de Prueba
**Cliente:**
- Usuario: `Tunombre`
- Contraseña: `Tunombre`

**Admin:**
- Usuario: `admin`
- Contraseña: `admin`

### 4. Características Implementadas

#### Pantalla de Login ✓
- [x] Recuperación de contraseña
- [x] Login con Google (simulado)
- [x] Validación de usuarios bloqueados
- [x] Cambio de idioma

#### Pantalla del Cliente ✓
- [x] BottomNavigationBar con 3 opciones (Compras, Pedidos, Yo)
- [x] Drawer con opciones de logout y salir
- [x] Música al iniciar/cerrar sesión

#### Página de Compras ✓
- [x] Visualización de productos (3 por defecto)
- [x] Selector de cantidad
- [x] Validación de stock
- [x] Realizar compra

#### Página de Pedidos ✓
- [x] Ver historial de pedidos del usuario
- [x] Estados del pedido: Pedido, En Producción, En Reparto, Entregado
- [x] Información completa del pedido

#### Página de Perfil/Contacto ✓
- [x] Editar perfil del usuario
- [x] Página de contacto con enlaces

#### Pantalla de Administrador ✓
- [x] Dashboard con 3 opciones principales
- [x] Gestión de Usuarios
  - Editar usuarios
  - Eliminar usuarios
  - Bloquear/Desbloquear usuarios
  - Crear nuevos usuarios (cliente o admin)
  
- [x] Gestión de Productos
  - Ver todos los productos
  - Crear nuevos productos
  - Editar productos
  - Eliminar productos
  - Modificar stock
  
- [x] Gestión de Pedidos
  - Ver todos los pedidos de todos los usuarios
  - Cambiar estado de pedidos

#### Multiidioma ✓
- [x] Soporte para español e inglés
- [x] Botón para cambiar idioma en AppBar

### 5. Generar APK Release

Una vez que hayas verificado que todo funciona en el emulador:

```bash
flutter build apk --release
```

El APK se generará en:
`build/app/outputs/flutter-apk/app-release.apk`

### 6. Notas Importantes

1. **Productos Predeterminados:** Se han agregado 5 productos de ejemplo en LogicaProductos.dart

2. **Música:** La música se inicia al hacer login y se detiene al logout

3. **Validaciones:** Se han implementado validaciones para:
   - No permitir compras sin seleccionar cantidad
   - No permitir cantidad superior al stock
   - No permitir login de usuarios bloqueados

4. **Persistencia:** Los pedidos se mantienen en memoria durante la sesión (se guardan en ServicioPedidos)

5. **Estructura de carpetas creadas:**
   - `/lib/l10n/` - Archivos de localización
   - `/lib/screens/paginas_cliente/` - Pantallas del cliente
   - `/lib/screens/paginas_admin/` - Pantallas del administrador

### 7. Solución de Problemas

Si al ejecutar encuentras errores de imports:
1. Ejecuta `flutter pub get`
2. Ejecuta `flutter clean`
3. Ejecuta `flutter pub get` nuevamente

Si tienes errores de versión de dependencias:
1. Actualiza las versiones en pubspec.yaml según sea necesario
2. Ejecuta `flutter pub get`

## Checklist Final

- [ ] Ejecutar `flutter pub get`
- [ ] Probar login con usuario y contraseña
- [ ] Probar recuperación de contraseña
- [ ] Probar cambio de idioma
- [ ] Comprar productos como cliente
- [ ] Ver pedidos realizados
- [ ] Editar perfil
- [ ] Ver página de contacto
- [ ] Acceder como administrador
- [ ] Gestionar usuarios (crear, editar, bloquear, eliminar)
- [ ] Gestionar productos (crear, editar, eliminar)
- [ ] Cambiar estado de pedidos
- [ ] Generar APK release

¡El proyecto está casi listo!
