#!/usr/bin/env python

import requests
import signal
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from pwn import *

squid = {'http': 'http://192.168.211.189:3128'}


def def_handler(sig, frame):
	print("\n\n[+] Saliendo...\n\n")
	sys.exit(1)


signal.signal(signal.SIGINT, def_handler)


def check_port(port, target, p1):
	endpoint = f"{target}:{port}"

	try:
		p = requests.get(endpoint,proxies=squid,timeout=3)

		p1.status(endpoint)

		if p.status_code == 200:

			print(f"[+] {endpoint} - HTTP {p.status_code}")

	except requests.RequestException:
		pass


def main():
	p1 = log.progress("Progreso")

	target = "http://192.168.211.189"

	with ThreadPoolExecutor(max_workers=20) as executor:
		futures = [
			executor.submit(check_port, port, target, p1)
			for port in range(1, 65536)
			]

		for future in as_completed(futures):
			try:
				future.result()
			except Exception:
				pass

	p1.success("Completado")


if __name__ == '__main__':
	main()
