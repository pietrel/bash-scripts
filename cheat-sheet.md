# Interesting snippets in Bash

Create or override file using **here document**

```bash
cat << 'EOF' > script.sh
#!/usr/bin/env bash
echo "Hello, World!"
EOF
```

`cat << 'EOF'` begins a **here document**, where everything typed after this line is treated as input until the delimiter `EOF` is reached.
The content between cat and EOF is sent to standard output.

The redirection operator (>) takes the output from cat and writes it to the file script.sh.
If script.sh already exists, it is overwritten. If it doesn't exist, it is created.

The quotes (') around EOF ensure that the content is treated literally (no variable or command substitution happens).

