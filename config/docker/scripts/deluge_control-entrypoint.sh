#!/bin/bash
cd /app/src;
alembic upgrade head;
cd deluge_control;
python3 main.py
