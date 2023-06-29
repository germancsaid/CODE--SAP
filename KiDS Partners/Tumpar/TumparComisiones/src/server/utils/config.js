import { config } from "dotenv";
config();

export const MONGODB_URI =
  process.env.MONGODB_URI || "mongodb+srv://germantardiop:driZnSFX7T3Pu5A5@tumpar.klpowsg.mongodb.net/tumpar_comisiones";


export const PORT = 
  process.env.PORT || 8082;