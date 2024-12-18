# Interesting snippets

```bash
cat << 'EOF' > arrays-01.sh
#!/usr/bin/env bash
names=('Alex' 'Ada' 'Alexandra')
names+=('Soto') # Appends element, Soto
unset names[3] # Removes element at index 3, (Soto)
echo ${names[0]} # Alex
echo ${names[1]} # Ada
echo ${names[2]} # Alexandra
# @ indicates all elements in the array
echo ${names[@]} # Alex Ada Alexandra
# Count of names
echo ${#names[@]} # 3
EOF
```

```bash
bash arrays-01.sh
```

