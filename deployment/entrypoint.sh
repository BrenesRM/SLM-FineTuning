#!/bin/bash

# Start Ollama in the background.
/bin/ollama serve &

# Record Process ID.
pid=$!

# Wait for Ollama to wake up.
sleep 5

echo "🔴 Retrieving model..."
ollama list

# Check if our model has been created.
if ! ollama list | grep -q "my-custom-model"; then
    echo "🟢 Model not found. Creating 'my-custom-model'..."
    # Navigate to directory where Modelfile and GGUF exist so relative paths work
    cd /root/models
    ollama create my-custom-model -f Modelfile
    echo "✅ Model created!"
else
    echo "🟢 'my-custom-model' already exists."
fi

# Wait for the background process to ensure container stays alive.
wait $pid
