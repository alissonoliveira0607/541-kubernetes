#!/bin/bash
PREFIX="172.16.1.10"

for i in {0..3}; do
  ssh -i ~/.ssh/windows devops@${PREFFIX}${i} -o StrictHostKeyChecking=no -o BatchMode=yes exit
  if [ $? -eq 0 ]; then
    echo "sucesso na conexão para ${PREFIX}${i}"
  else
    echo "erro na conexão para ${PREFIX}${i}"
  fi
done
