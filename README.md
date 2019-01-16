# AutomaticRogueLife: 
###### Desarrollado por Fernando González Petit en lenguaje Prolog
  Version 1.0

### Introducción: 
> Breve descripción de funcionamiento y propósito del programa

AutomaticRogueLife es, en esencia, un juego estilo roguelike, con la particularidad de que la lógica y las funciones de juego están implementadas en Prolog. Mi propósito es crear una aplicación interactiva y a la vez de operación automática que simule la experiencia de los juegos de rol de ordenador viejos, basados en decisiones.

En el juego, "controlas" a un personaje ("Hiro" por defecto) que acaba de despertar en un subterráneo junto a su amigo Julian. Su misión es encontrar al resto de compañeros en el subterráneo, recopilar los recursos necesarios para abrirse paso por la 'dungeon' y abrir la trampilla que lleva al exterior. Cada uno de sus amigos tiene algo importante para salir, así que lo más probable es que pases por cada uno de ellos hasta encontrar la salida y tener lo necesario regresar a la superficie.

###### Notas de versión: La idea es añadir funcionalidad con el tiempo; por el momento el programa está en un estado en el que el juego es demasiado secillo, pero mejorar la experiencia de usuario y añadir funcionalidades con el tiempo es mi idea.

### Notas de implementación:
> Resumen de funcionalidad y descripción de relaciones más importantes en la lógica del programa.

El 'mundo' del juego, consta en una matriz. Pero espera, ¿cómo va a ser una matriz si Prolog no es un lenguaje de programación orientado a objetos? La respuesta es sencilla: *Como todos los objetos del juego, se simula a través de lógica*

Una matriz se basa en las siguientes normas:
  - **Definición de adyacencia de números** -> 1 es adyacente a 2, 2 no es adyacente a 4
  - **Definición de "casilla"** -> Una casilla en una lista con dos elementos numéricos, un par [X, Y]. X horizontal, Y vertical, para hacerse la imagen mental.
  - **Definición de adyacencia de casillas** -> Una casilla es adyacente a otra si una de las coordenadas es adyacente con la respectiva en la otra.
  - **Importante: Tamaño del mundo** -> Se fuerza a que el valor de WorldSize (WS) sea un número determinado. Solo se permitirán casillas cuyas coordenadas estén en el rango (1..WS)
  - **Elementos que 'viven' en el mundo** -> Desde el personaje que manejamos hasta NPC's y monstruos e incluso contando la trampilla de salida.
  
Empecemos por los NPC's. Al subterráneo bajan contigo (Julian, Abigail, Nero, Margarette). Esta es su posición en la lista de la base de conocimiento y se puede conocer su posición a través de la relación where_is(NPC, Pos). 
  - Al dar con un NPC, generalmente se parará el movimiento automático. Al hablar con ellos por primera vez, te darán sus respectivos **objetos importantes**: 
    + Nero tiene un arma. Más de una, de hecho. No preguntes por qué.
    + Abigail tiene la llave. Es buena encontrando cosas, qué decir.
    + Margarette sabe donde se encuentra la salida (en un futuro podría saber la ubicación de otros lugares importantes)
    + Julian sabe donde está Abigail.

Por otro lado están los monstruos. Son entes inmóviles localizados aleatoriamente en el mapa. De momento no tienen mucha mayor relevancia, aunque la idea es que supongan una verdadera amenaza para el agente.

Ahora, en cuanto al agente lógico que operamos, nuestro personaje:
  - **Atributo posición** -> Un valor dinámico que indica la casilla
  - **CurrentGoal o 'meta actual'** -> Un valor dinámico que indica el destino hacia el que se mueve el agente automáticamente.
  - **Vector de casillas visitadas** -> En la versión actual, permite la traza del recorrido que realiza el agente cuando se le pide moverse.
  - **Vector de percepciones** -> El agente no es omnisciente, sino que cuenta con un vector sencillo de percepciones que le permiten relacionarse con el resto de elementos en el mundo:
    + Vista: El agente tiene ojos para las casillas inmediatamente adyacentes. Puede ver la luz de un fuego u hoguera, lo que indicaría que hay un NPC cerca.
    + Olfato: Si detecta que huele mal en las casillas adyacentes sabrá que hay un monstruo. Trataré su patrón de actuación en profundidad para estos casos más adelante.
    + Sensación de viento: Un motivo un tanto abstracto, pero el agente interpreta el flujo de aire como la presencia.
  - **Posesión de arma** -> Solo con un arma en mano puedes hacer frente a los monstruos del subterráneo.
  - **Posesión de llave** -> Solo con la llave puedes salir de la mazmorra.

#### El jugador

En cualquier videojuego, al final, es el elemento más importante. La experiencia del usuario es en sí un aspecto relevante para el programa y se ha tenido en cuenta en el desarrollo en todo momento. Esto genera también una serie de dificultades asociadas, pero es a su vez parte de la magia del asunto.

Para poner en marcha el juego con nuevos valores de aleatoriedad y desde el inicio, el usuario debe cargar la base de conocimiento y escribir "start." en la terminal de Prolog. 

###### Nota de versión(1.0): 
A partir de aquí, el patrón de juego es relativamente simple y cuenta con los siguientes comandos:
  - **"behave"** -> ordena al agente interactuar con el entorno. Esta interacción supone hablar con NPC's, actuar ante monstruos o abrir la trampilla para salir (si se tiene la llave, claro)
  - **"move"** -> ordena al agente desplazarse hacia la meta actual. Si al inicio del trayecto hay un monstruo lo despertará.   
  - **"talk"** -> Habla con la persona cercana. **//BUG REPORT:** Existe la posibilidad de conflicto si tienes varios NPCs cerca al mismo tiempo.
  - **"try_and_leave"** -> Si tienes la llave y estás cerca de la salida, puedes irte.
  - **"oneStep"** -> Avanza solo un paso hacia la meta actual. No despiertas a los monstruos si le indicas esta acción.
  - **"help_me"** -> Muestra la ayuda de comandos.
  
  
### Desarrollo del programa
> Descripción breve de la fase de desarrollo del programa en alto nivel.

La idea está inspirada en el modelo de "El Mundo de Wumpus" y como ya mencioné, en los videojuegos de rol antiguos*. Muchos de los conceptos estaban en mi cabeza desde el principio, pero también he tenido que tomar decisiones de implementación sobre la marcha, ya que mi planteamiento inicial no era perfecto (normalmente por no ajustarse *perfectamente* a la lógica proposicional del lenguaje).

Ya que es mi segundo idioma natural, por comodidad y escalabilidad he escrito todo el programa directamente en inglés.

En cuanto a las dificultades a lo largo del desarrollo del programa, a modo de curiosidad, las comento a continuación:
  - Empecé el programa teniendo una idea muy básica de Prolog, así que ha supuesto un trabajo de investigación extra. Además, como probablemente a todo el que empiece con el lenguaje, ha sido especialmente complicado habituarme a lo estricto de las formas lógicas y al cambio de paradigma.
  - El enfoque del programa está en constante evolución. Por un lado eso me aporta flexibilidad en el desarrollo, lo cual está bien; pero por otro, implica que tengo que *limitar* mi propia imaginación y proponerme metas realistas a corto plazo si quiero avanzar. 
  - La extensión del código aumenta exponencialmente con cada añadido y el editor de Prolog (al menos para Windows) es, a veces, incómodo, por lo que debo llevar un seguimiento de lo que hago y dejo de hacer. Para esto ha ayudado el control de versiones en git.
  - La adaptación de mis conocimientos generales de programación a la programación lógica supuso un reto al principio, pero todo es cuestión de acostumbrarse, supongo. Y de saber cómo funciona la lógica proposicional.  
  - La encapsulación que ofrece Prolog es bastante limitada. Esto es un inconveniente grande para un videojuego real, ya que tienes que confiar en la buena fé del usuario y... no suele ser una buena idea para un producto software. Sin embargo, puesto que esto no entra dentro de esa clasificación, no hay problema. 
###### *Nota de versión (1.0): Aunque la complejidad del diálogo en este momento no es extremadamente alta  

### Futuras versiones
> Ideas para futuras implementaciones y funcionalidades.
  
  - Mejora y mayor complejidad de la interacción con monstruos.
  - Mejora de los diálogos y posible introducción de decisiones.
  - Diferentes rangos de monstruos, boss final y stats para el personaje y enemigos.
  - Mejora del sistema de armas
  - El agente se parará si encuentra a alguien o algo por el camino digno de su atención.   

