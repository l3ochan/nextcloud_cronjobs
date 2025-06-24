#!/bin/bash

# Nextcloud Dir
NEXTCLOUD_DIR="/var/www/nextcloud"

# Custom jobs dir
JOBS_DIR="/var/www/nextcloud/scripts"  # <-- À adapter (ex: /opt/nextcloud-jobs)

# STEP1 1 : Launching PHP cronjob (default nextcloud cronjob) 
echo "=== [STEP1 1]: Launching PHP cronjob (default nextcloud cronjob) ==="
cd "$NEXTCLOUD_DIR" || {
  echo "[CRITICAL]: Impossible d'accéder à $NEXTCLOUD_DIR"
  exit 1
}

if ! php -f cron.php; then
  echo "[ERROR]: Error while executing cron.php. Continuing..."
fi

# [STEP2 2]: Executing custom jobs from JOBS_DIR
echo "=== [STEP2 2]: Executing custom jobs from JOBS_DIR ==="

# Lists all scripts in the jobs solder
for script in "$JOBS_DIR"/*.sh; do
  if [[ -x "$script" ]]; then
    echo "→ [INFO]: Launching : $script"
    if ! bash "$script"; then
      echo "[ERROR]: The script $script failed. Continuing..."
    fi
  else
    echo "[WARN]: $script could not be launched."
  fi
done

echo "[SUCCESS]: Orchestration of automated jobs finished."
