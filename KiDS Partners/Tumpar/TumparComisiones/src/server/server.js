// Importamos la aplicación de Express desde el archivo app.js
import app from "./app";
// Importamos el módulo 'http' para crear el servidor HTTP
import http from "http";
// Importamos la clase 'Server' del módulo 'socket.io'
import { Server as WebsocketServer } from "socket.io";
// Importamos el archivo 'socketServer.js' que contiene la lógica del servidor de socket
import sockets from "./socketServer";
// Importamos la constante 'PORT' del archivo 'config.js'
import { PORT } from "./utils/config";
// Importamos la función 'connectDB' del archivo 'db.js'
import { connectDB } from "./utils/db";
// Conectamos a la base de datos
connectDB();
// Importamos el módulo 'passport' para autenticación de usuarios
import passport from 'passport';
// Importamos la variable 'sessionMiddleware' desde el archivo 'app.js'
import { sessionMiddleware } from "./app";

const server = http.createServer(app); // Creamos el servidor HTTP a partir de la aplicación de Express
const io = new WebsocketServer(server); // Inicializamos el servidor de socket.io

const wrap = middleware => (socket, next) => middleware(socket.request, {}, next); // Función para convertir middleware de Express a Socket.IO

io.use(wrap(sessionMiddleware)); // Utilizamos el middleware 'sessionMiddleware' de Express en el servidor
io.use(wrap(passport.initialize())); // Inicializamos Passport
io.use(wrap(passport.session())); // Utilizamos la sesión de Passport

// Middleware para verificar si el usuario está autenticado
io.use((socket, next) => socket.request.user ? next() : next(new Error('unauthorized')));

const httpServer = server.listen(PORT); // Iniciamos el servidor HTTP
console.log("Server running on port", PORT);

sockets(io); // Importamos la lógica del servidor de socket desde el archivo 'socketServer.js'
