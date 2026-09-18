# PrototipadoN8N

Chatbot con IA: **Flutter** como frontend que conversa con un workflow de **n8n**, el cual orquesta la llamada a un modelo de lenguaje a través de **OpenRouter**.

## Arquitectura

```
Flutter (Frontend)  --POST JSON {"message": ...}-->  n8n Webhook  --HTTP-->  OpenRouter (DeepSeek V4 Flash)
        <--JSON {"reply": "..."}---------------------  Respond to Webhook  <--respuesta del modelo
```

## Estructura

- `Bankend/workflow.json` — Workflow de n8n importable (Webhook → Extraer mensaje → HTTP Request a OpenRouter → Respond to Webhook).
- `Frontend/` — App de chat en Flutter (campo de texto, burbujas, auto-scroll, manejo de errores).

## Puesta en marcha

### 1. Backend (n8n)

1. En n8n: **Workflows → Import from File** y selecciona `Bankend/workflow.json`.
2. Crea una credencial tipo **Header Auth**:
   - **Name**: `OpenRouter API`
   - **Header Name**: `Authorization`
   - **Header Value**: `Bearer <TU_OPENROUTER_API_KEY>`
3. En el nodo **"Llamar a OpenRouter"**, selecciona la credencial `OpenRouter API`.
4. Clic en **Publish** (arriba a la derecha) para activar el workflow.
5. La URL de producción será `http://localhost:5678/webhook/chat`.

Prueba rápida:

```bash
curl -X POST http://localhost:5678/webhook/chat \
  -H "Content-Type: application/json" \
  -d "{\"message\":\"hola\"}"
```

Debería devolver `{"reply":"..."}`.

> El nodo **"Prueba manual"** permite ejecutar todo el flujo desde n8n sin necesidad de una petición externa, usando un mensaje de muestra.

### 2. Frontend (Flutter)

1. En `Frontend/lib/main.dart`, verifica la constante `n8nWebhookUrl`:
   ```dart
   const n8nWebhookUrl = 'http://localhost:5678/webhook/chat';
   ```
2. Instala dependencias:
   ```bash
   flutter pub get
   ```
3. Corre la app:
   ```bash
   flutter run -d chrome
   ```

## Notas

- **Android emulator**: usa `http://10.0.2.2:5678/webhook/chat` en vez de `localhost` (el emulador no ve el `localhost` de tu máquina).
- **CORS**: el workflow deja `*` como origen permitido para pruebas; en producción cambia ese valor por la URL real de tu frontend.
- **API key**: no se almacena en el repositorio. Se guarda en una credencial de n8n (Header Auth). Si alguna vez se expone, revócala en tu dashboard de OpenRouter y genera una nueva.
- El modelo usado es `deepseek/deepseek-v4-flash` (OpenRouter). Se puede cambiar en el `jsonBody` del nodo "Llamar a OpenRouter".