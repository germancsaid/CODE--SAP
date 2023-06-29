import { Schema, model } from "mongoose";

const parametroSchema = new Schema({
  Parametro: {
    type: String,
    required: true
  },
  Rango: [
    {
      min: {
        type: Number,
        required: true
      },
      max: {
        type: Number,
        required: true
      },
      tasa: {
        type: Number,
        required: true
      },
      monto: {
        type: Number,
        required: true
      }
    }
  ],
  Sucursal: {
    type: String,
  },
  Tipo: {
    type: String,
  },
});

export default model("Parametro", parametroSchema);


