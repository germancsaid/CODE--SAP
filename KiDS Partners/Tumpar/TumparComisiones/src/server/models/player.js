/**
 * *Creacion del schema de la coleccion
 */

//import { Schema } from "module";
import { Schema, model } from "mongoose";

const schema = new Schema(
  {
    PlayerName: {
      type: String,
    },
    NickName: {
      type: String,
    },
    Email: {
      type: String,
    },
    Password: {
      type: String,
    },
    TeamName: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

/**
 * *Se exporta la coleccion con una 's' al final
 */
export default model("player", schema);
