# SLM Fine-Tuning & Ollama Deployment

**Course Project: Build Your Own Local AI Model**

This project demonstrates how to **fine-tune** a Small Language Model (SLM), specifically `Llama-3-8B`, using **Unsloth** on Google Colab, and then deploy it locally using **Docker** and **Ollama**.

## 🧠 Key Concepts

- **SLM (Small Language Model)**: Examples include Llama 3 8B, Mistral 7B. "Small" enough for consumer hardware.
- **Fine-Tuning**: Improving a pre-trained model on a specific dataset.
- **LoRA**: Efficient fine-tuning adapter.
- **GGUF**: Format for running LLMs on CPUs/Consumer GPUs.
- **Ollama**: Tool to run LLMs locally.

## Project Structure

- `fine_tuning/`:
  - `FineTune_SLM.ipynb`: **The Brain**. Jupyter Notebook for training.
  - `train.csv`: **The Knowledge**. Dataset for training.
- `deployment/`:
  - `Dockerfile`: Custom image setup.
  - `docker-compose.yaml`: Orchestration for Ollama + WebUI.
  - `Modelfile`: Model configuration.
  - `entrypoint.sh`: Automation script.

## ✅ Prerequisites

1.  **Google Account**: To access [Google Colab](https://colab.research.google.com/).
2.  **Docker Desktop**: Installed and running on your machine. [Download here](https://www.docker.com/products/docker-desktop/).

---

## 🚀 Step-by-Step Guide

### Phase 1: Fine-Tune the Model (The "Learning" Phase)

1.  **Open Google Colab**: Go to [Google Colab](https://colab.research.google.com/).
2.  **Upload the Notebook**: Click `Upload` and select `fine_tuning/FineTune_SLM.ipynb` from this project.
3.  **Upload Data**: In the Colab sidebar (folder icon), upload `fine_tuning/train.csv`.
4.  **Enable GPU**:
    - Go to **Runtime** > **Change runtime type**.
    - Select **T4 GPU** (Hardware accelerator).
5.  **Run the Notebook**:
    - Execute the cells step-by-step.
    - **CRITICAL STEP**: The last cells in the notebook usually handle saving to GGUF. Ensure you run the cell that says `model.save_pretrained_gguf(...)`.
    - This will generate a file, often named `unsloth.Q4_K_M.gguf` (or similar), in the Colab files sidebar.
6.  **Download the Model**:
    - Right-click the generated `.gguf` file in the Colab sidebar and select **Download**.
    - _Note: This file is large (approx 5GB), so the download may take some time._

### Phase 2: Deploy with Docker (The "Serving" Phase)

1.  **Prepare the Deployment Folder**:

    - Open the `deployment/` folder on your local machine.
    - **Move** the downloaded GGUF file into this folder.
    - **RENAME** the file to: `my-finetuned-model.gguf`.
    - _Check_: Your `deployment/` folder should now contain `Modelfile`, `docker-compose.yaml`, `Dockerfile`, `entrypoint.sh`, and `my-finetuned-model.gguf`.

2.  **Launch the System**:

    - Open a terminal/PowerShell inside the `deployment/` folder.
    - Run the following command:

    ```bash
    docker-compose up -d --build
    ```

    - _The `--build` flag ensures it rebuilds the specific image for your project._

3.  **Monitor Progress**:

    - To verify the model is being created, view the logs:

    ```bash
    docker logs -f ollama
    ```

    - Wait until you see the message: `✅ Model created!`
    - Press `Ctrl+C` to exit the logs view.

### Phase 3: Use Your Model

**Option A: Chat via Web Browser (Open WebUI)**

1.  Open your browser to `http://localhost:3000`.
2.  Sign up (this creates the local admin account).
3.  In the chat interface, look for the model selector dropdown.
4.  Select `my-custom-model`.
5.  **Test it**: Ask a question from your training data, e.g., "Explain how Juank and Victor N fun".

**Option B: Chat via Terminal**

Run this command to talk directly to the model:

```bash
docker exec -it ollama ollama run my-custom-model
```

**Option C: Verify API (PowerShell)**

```powershell
curl http://localhost:11434/api/generate -d '{
  "model": "my-custom-model",
  "prompt": "What do you know about Juank and Victor N?",
  "stream": false
}'
```

---

## ❓ Troubleshooting

**"The model doesn't answer my custom questions!"**

- **Cause**: You might still be running the base Llama 3 model.
- **Fix**: Ensure you downloaded the _finetuned_ GGUF file from Colab, renamed it to `my-finetuned-model.gguf`, and placed it in the `deployment/` folder. Check `deployment/Modelfile` ensures it says `FROM ./my-finetuned-model.gguf`.

**"Model not found" error**

- Check the docker logs (`docker logs ollama`). If the `entrypoint.sh` couldn't find the `.gguf` file, it might have failed to create the model.
