import { connect, set } from "mongoose";
import { MONGODB_URI } from "./config";

export const connectDB = async () => {
  set("strictQuery", false);
  
  try {
    await connect(MONGODB_URI); //definir en el proveedor en la nube esta variable para el link de la
    console.log("Conexion exitosa base MONGO DB");
  } catch (error) {
    console.error(error);
  }
};
