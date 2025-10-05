errrors 
rm -rf /homeless-shelter 2>/dev/null || true

ops pkg load eyberg/node:20.5.0 -p 8083 -f -n -a hi.js
