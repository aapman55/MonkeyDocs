# Useful bash snippets

## Split string by newline

```bash
readarray -t output_variable_name <<<"$variable_containing_string"
```

## If statement

```bash
if [ condition ]
then
  do_something
else
  do_something_else
fi
```

It is important to have a space between the square brackets and the condition. Otherwise it will
result in an error.

## Arrays
Array elements are accessed using curly brackets to indicate an array command and square brackets
to indicate which index you want to access.

```bash
${array_variable[1]}
```
Where the 1 indicates the second entry.

You can also do a count on the array.
```bash
${#array_variable[@]}
```

## Parse input parameters

```bash
for i in "$@"; do
  case $i in
    -var1=*|--variable1=*)
      VARIABLE1="${i#*=}"
      ;;
    -vae2=*|--variable2=*)
      VARIABLE2="${i#*=}"
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done
```