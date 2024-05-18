# hello.py
import sys

def main():
    while True:
        try:
            # Read data from Erlang
            data = sys.stdin.buffer.read()
            if not data:
                break
            # Process the data (you can modify this part)
            response = b"Hello, " + data
            # Send the response back to Erlang
            sys.stdout.buffer.write(response)
            sys.stdout.flush()
        except KeyboardInterrupt:
            break

if __name__ == "__main__":
    main()
