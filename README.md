# Auto Survival: Sustancias

Proyecto Godot que implementa un juego de supervivencia automática inspirado en "bullet heaven" donde el personaje ataca de forma autónoma y el jugador debe sobrevivir el mayor tiempo posible.

## Requisitos

- [Godot Engine 4.x](https://godotengine.org/) con soporte para GDScript.

## Estructura principal

- `scenes/` contiene las escenas del menú, juego principal, jugador, proyectiles y enemigos.
- `scripts/` incluye la lógica del jugador, enemigos, gestor de sustancias, spawner, HUD y pantallas auxiliares.
- `ui/` almacena las escenas de interfaz de usuario reutilizables (HUD, selección de sustancias, pantallas de menú, etc.).

## Cómo ejecutar

1. Abre Godot 4.x y carga el proyecto desde `project.godot`.
2. Ejecuta la escena principal (`scenes/MainMenu.tscn`) o lanza directamente el proyecto con el botón **Play**.
3. Desde el menú principal puedes iniciar una partida, revisar los récords guardados, abrir la configuración o los créditos.

## Mecánicas implementadas

- **Movimiento libre** del jugador con las teclas WASD o flechas.
- **Ataque automático** que lanza píldoras hacia el enemigo más cercano con frecuencia ajustable y cantidad de proyectiles escalable.
- **Sistema de XP y niveles** con orbes recogibles y requisitos crecientes por nivel.
- **Selección aleatoria de sustancias** al subir de nivel, cada una con efectos positivos y consecuencias negativas acumulables hasta cinco niveles.
- **Gestión dinámica de enemigos** que incrementa su salud y frecuencia según el nivel del jugador y las sustancias elegidas.
- **HUD completo** con vida, nivel, barra de experiencia, daño por proyectil y número de proyectiles activos.
- **Pantalla de fin de partida** que muestra estadísticas de la carrera y las sustancias elegidas, con opción de reintentar o volver al menú.

Los datos de récords (mejor tiempo y cantidad de eliminaciones) se guardan automáticamente en el directorio de usuario de Godot.
