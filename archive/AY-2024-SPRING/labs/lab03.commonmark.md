---
title: "{{< var course.short >}} Week 3 In-Class Activity: `R`, These are your First Steps"
format: live-html
engine: knitr
---


::: {.cell}

:::






# Welcome!

[Slides](../slides/slides03.qmd)

# Vector Semantics in `R`

`R` works with _3_ core principal structures: 

- Vectors: an ordered (one-dimensional) collection _of the same type_
  - Numeric (real number / double), Integer, Character, Logical (Boolean)
  - Scalars (single values) are just vectors of length 1
- Lists: an ordered collection of arbitrary objects (other vectors, other lists, *etc*)
- Data Frames: ordered tabular database (think SQL tables)
  - Next week, we'll discuss these in detail
  
This week, our primary focus is on _vectors_. 

## Review of `R`

In this section, we will review some of the basic 'built-in' features of `R`.  In the next section (`Packages`) we will discuss how to add to the "base-bones" functionality. 
When working with `R`, there are two interacting 'subsystems' in play:

- The `R` language and interpreter: this is the part of `R` that is similar
  to `python` or `C`/`C++`. You will write `R` code in the `R` language and the
  `R` interpreter will run that code. The fact that all of these elements are
  called `R` is a bit confusing, but once you get the hang of things, the distinctions
  will melt away.
- `R` packages: When working in `R`, you do not have to start from scratch every
  time. Other programmers make `sets` of code available to you in the form of
  `packages`. For our purposes, a package can contain two things:
  - Pre-written functions to help you achieve some goal
  - Data sets
  Most of the time, the primary purpose of a package is sharing functions and code: 
  there are easier ways to share data with the world.

When you first downloaded `R`, you downloaded the interpreter and a set of base 
packages written by the "R Core Development Team". 

Run the following code to see what your `R` environment looks like:





::: {.cell}

```{webr}
sessionInfo()
```

:::





Compare the output of running this here-in the browser-with what you get by running
`sessionInfo()` on your machine. 

There is lots of useful information here, including

- the version of `R` being used
- the operating system
- the numerical linear algebra libraries (BLAS, LAPACK) used
- system language and time zone information
- loaded packages

When asking for help, always include the output of the `sessionInfo()` command
so that your helper can quickly know how your system is configured. 

### Packages

`R` code is distributed as _packages_, many of which come included with `R` by 
default. These are the `base` packages, and they are noted in your `sessionInfo()`. 
But we can do _many_ more things with `R` using contributed (non-base) packages!

The most common platform for distributing `R` packages is `CRAN`, the Comprehensive
R Archive Network, available at [https://cran.r-project.org/](https://cran.r-project.org/). You have likely already
visited this site to download `R`. The `available.packages()` function in `R` lists
all packages currently on `CRAN`. We can see that there are _many_: 





::: {.cell}

:::

::: {.cell}
::: {.cell-output .cell-output-stdout}

```
[1] 22451
```


:::
:::





If you want to use a contributed package, you need to do two things: 

1. Download it from CRAN and install it onto your computer (one time)
2. Load it from your hard drive into `R` (every time you restart `R`)

The first step - download and install - can be completed using the `install.packages()`
function. For example, to install the [`palmerpenguins` package](https://allisonhorst.github.io/palmerpenguins/), I would run: 





::: {.cell}

```{.r .cell-code}
install.packages("palmerpenguins")
```
:::





This will automatically download and install this package for me. `R` is helpful
and also tries to automatically install all packages that a given package relies upon.
Because of this, it is often sufficient to install the "last step" and trust `R` to
handle the dependencies automatically. In this course, most of the packages we use
can be automatically installed by installing the `tidyverse` package. 





::: {.cell}

```{.r .cell-code}
install.packages("tidyverse")
```
:::





Note that there really isn't much in the `tidyverse` package we want, but it's a
useful proxy for a much larger set of packages. 

Once a package is installed, we need to load it into `R` with the `library` function:





::: {.cell}

```{.r .cell-code}
library(palmerpenguins)
```
:::





After doing this, we have access to the contents of the `palmerpenguins` package
until we restart `R`. 

::: {.callout-danger}

Note that the `install.packages` function wants you to quote its argument, but
`library` does not. This is a weird historical quirk of `R` that you will trip
up on many times before this course ends. 





::: {.cell}

```{.r .cell-code}
install.packages("tidyverse")
library(tidyverse)
```
:::




:::

For example, `palmerpenguins` package provides a data set of penguin measurements.
If we try to get the data set without loading `palmerpenguins`, we get an error message: 





::: {.cell}

```{webr}
penguins
```

:::





After we install and load `palermerpenguins`, we are good to go: 





::: {.cell}

```{webr}
install.packages("palmerpenguins")
library(palmerpenguins)
head(penguins, 10) # Print only the first 10 rows of penguins
```

:::





So much tuxedo goodness!

In general, if you get a error message of the form `Error: object 'X' not found`,
you should: 

1. Make sure you spelled `X` properly
2. If `X` comes from a package, make sure you `library()` that package. 

There's no harm to `library()`-ing a package multiple times; if you
`install.packages()` a package that you have already loaded, you may need to 
restart `R`. 

::: {.callout-danger}

As mentioned last week, I ***strongly*** recommend **never** saving your workspace
in `R` or `RStudio`. One of the things "saved" in a workspace is the list of loaded
packages, so it becomes essentially impossible to reinstall a package properly.

:::

### Variables and Assignment


Whenever you type a "word" of `R` code, it must be one of three things:

- A reserved word: this is a small set of `keywords` that `R` keeps for its own use. 
  These have special rules for their use that we'll learn as we go along. The main
  ones are: `if`, `else`, `for`, `in`, `while`, `function`, `repeat`, `break`, and `next`. 
  
  If you use one of these words and get a weird error message, it's likely 
  because you aren't respecting the special rules for these words.
  
  For the nitty gritty, see the `Reserved` help page but feel free to 
  skip this for now. The `Control` help page gives additional details. 
  
  (When you run a help page in this tutorial, it looks a bit funny. 
   Try running `?Reserved` directly in `RStudio` for better formatting.)
- A "literal". This is a word that represents "just the thing" without any additional
  indirection. The most common types of literals are: 
  - Numeric: *e.g.*, `3`, `42.0`, or `1e-3`
  - String: *e.g.*, `'a'`, `"beach"`, or `'cream soda'`
  There are a few rules for literals, but the most important is that strings
  begin and end with the same character, either a single quote or a double quote. 
  When `R` sees a single quote, it will read _everything_ until the next single
  quote as one string, even if there's a double quote inside.

  Try some literals:




::: {.cell}

```{webr}
42
"a"
"3 + 4"
'if I go to 4 beaches, I will shout "hurray!"'
```

:::




  What does the literal `0xF` represent? (You don't need to worry about why. This
  is a fancier literal than we will use in this class.)
- A "variable name". This is the most common sort of "word" in code. It is used
  to _something_ without actually having to know what it is. 

  We can create variables using the "assignment" operator: `<-`




::: {.cell}

```{webr}
x <- 3
x
```

:::




  When you read this outloud, read `<-` as "gets" so `x <- 3` becomes
  "x gets 3."

  When we use the assignment operator on a variable, 
  it overwrites the value of a variable silently and without warning




::: {.cell}

```{webr}
x <- 3
x
x <- 5
x
```

:::




  We also put expressions on the right hand side of an assignment: 




::: {.cell}

```{webr}
x <- 1 + 2
x
y <- sin(pi / 2) ## Radians!
y 
```

:::




  Also note the trick we've used here a few times: a "plain" line of code
  without an assignment generally prints its value.
  
### Comments

When you include a `#` symbol, `R` will ignore everything after it. This is
called a *comment* and you can use it to leave notes to yourself about what you
are doing and why. 

### Vector Data Types

A _vector_ is a ordered array of the same _sort_ of thing (*e.g.*, all 
numbers or all strings).  We can create vectors using the `c` command (short
for concatenate). 




::: {.cell}

```{webr}
x <- c(1, 2, 3)
x
y <- c("a", "b", "c")
y
```

:::





::: {.callout}
Change the above example to `c(1, "a", 3)` and examine the output. 
What happened? Why?

:::

To see the _type_ (sort) of a vector, you can use the `str` command. 




::: {.cell}

```{webr}
x <- c(1, 2, 3)
str(x)
```

:::





`str(x)` tells us about the _structure_ of `x`. Here, we see that `x` is a _numeric_
vector of length 3. 

`R` will try to do the right thing when doing arithmetic on vectors.




::: {.cell}

```{webr}
x <- c(1, 2, 3)
x + 5
```

:::

::: {.cell}

```{webr}
x <- c(1, 2, 3)
y <- c(4, 5, 6)
x + y
```

:::





When you give `R` vectors of different lenghts, it will "recycle" the shorter one
to the length of the longer one. 




::: {.cell}

```{webr}
x <- c(1, 2, 3, 4)
y <- c(10, 20)
x + y
```

:::





This can be a double-edge sword when the two vectors don't fit together so nicely:




::: {.cell}

```{webr}
x <- c(1, 2, 3)
y <- c(4, 5)
x + y
```

:::





::: {.callout}

How was the last element of `x+y` computed? 

:::

Here we see also that `R` printed a _warning_ message. A _warning_ message is `R`'s
way of saying "something is funny, but I can still do this" while it (successfully)
implements your command. It's here to help you, but sometimes can be safely ignored
if you're sure about what you're doing.

An _error_ is a "I can't do this" message. When `R` encounters an `error` 
it stops and does not fully execute the command




::: {.cell}

```{webr}
x <- c(1, 2, 3)
y <- c("a", "b", "c")
x * y
```

:::




Here we get an error because there is no meaningful way to multiply a string 
by a number, unlike earlier where the recycling rule told `R` what to do, 
even if it was probably a bad idea.

## Functions

### Functions

In many of these exercises, we have used commands that have the form 
`NAME()` with zero or more comma-separated elements in the parentheses. 

This represents a _function_ call. Specifically, the command
`func(x, y)` calls the function named `func` with two _arguments_ `x` and `y`.

Functions are the _verbs_ of the programming world. They are how anything gets done.
So far, we've only used some basic functions: 

- `c`: the concatenate function
- `print`: the print function
- `str`: the structure function
- `list`: the list making function

But there are tons of other useful ones!

Try these out: 
- `length` on a vector
- `colnames` on a data frame (like `PlantGrowth`)
- `toupper` on a string (vector)
- `as.character` on a numeric value





::: {.cell}

```{webr}
x <- c(1, 2, 3, 4, 5)
length(x)
colnames(PlantGrowth)
y <- c("Baruch", "CUNY", "Zicklin")
toupper(y)
as.character(cos(pi))
```

:::





#### Arguments: Positional and Keyword

The _inputs_ to a function are called the arguments. They come in two forms: 
- Positional
- Keyword

So far we have only seen positional arguments. The function interprets them in an 
order that depends on they were given: 




::: {.cell}

```{webr}
x <- 3
y <- 5
paste(x, y)
paste(y, x)
```

:::




Here `paste` combines two values into a string. We get different output strings
depending on the order of the input.

Other arguments can be passed as _keyword_ arguments. Keyword arguments come with
names that tell functions how to interpret them. For example, the `paste` function
has an optional keyword argument `sep` that controls how the strings are combined. 




::: {.cell}

```{webr}
x <- 3
y <- 5
paste(x, y, sep="+")
paste(y, x, sep="><><")
```

:::




Keyword arguments typically have defaults so you don't need to always provide them.
For the `paste` function, the `sep` defaults to `" "`.

### Creating Your Own Functions

When you want to create your own function, you use a variant of the assignment
structure





::: {.cell}

```{.r .cell-code}
my_addition <- function(x, y) {
    x + y
}
```
:::





Let's break this into pieces: 

- On the left hand side of the assignment operator `<-`, we see the function name. 
  This works exactly the same as vector assignment.
- Immediately to the right of the assignment operator, we see the keyword `function`.
  This tells `R` that we are defining a function. 
- After the word function, we see the "argument list", *i.e.*, the list of inputs
  to the function (comma separated). Here, we are not providing default values
  for any function. 
- Finally, between the curly braces, we get the _body_ of the function. This is
  actually the code defining a function's behavior. You can do basically anything 
  here! Define variables, do arithmetic, load packages, call other functions - 
  it's all valid.  (In fact, you can even define a function within a function, but
  that's sort of advanced.)
- The last line of the body (here the only line) defines the _return_ value of 
  the function, *i.e.*, its output. 
  
This function will add two numbers together. Now that we've defined it, we can
use it just like a built-in function: 





::: {.cell}

```{.r .cell-code}
my_addition(2, 4)
```

::: {.cell-output .cell-output-stdout}

```
[1] 6
```


:::
:::





**Tip**:  You can see the code used to define any function by simply printing it:
think of the code as being the "value" and the function name as the variable name.
(This isn't actually just a metaphor - it's literally true!)

#### Default Arguments

Sometimes, we want functions to have _default_ but changeable behvaior. This is 
_default arguments_ come in. If the user provides a value, the function uses it,
but otherwise the default is used. 

For example, 





::: {.cell}

```{.r .cell-code}
make_bigger <- function(x, by=2){
    x + by
}

make_bigger(3)
```

::: {.cell-output .cell-output-stdout}

```
[1] 5
```


:::

```{.r .cell-code}
make_bigger(3, by = 3)
```

::: {.cell-output .cell-output-stdout}

```
[1] 6
```


:::
:::





Here `by` defaults to `2`, but the user is required to supply `x` because it
has no default. 





::: {.cell}

```{.r .cell-code}
make_bigger(by=3)
```

::: {.cell-output .cell-output-error}

```
Error in make_bigger(by = 3): argument "x" is missing, with no default
```


:::
:::





There are lots of details in the mechanics - they even can be 'dynamic' using
some tricks - but in general, they should "just work."

## Control Flow

So far, all of the code we have written executes _linearly_, one line at a time.
To write complex programs, however, we sometimes need code to execute in 
other ways: *e.g.*, going line by line through a complex data set running the same
code (a "loop") or doing different things depending on the value of a variable
(a "conditional"). This brings us to the topic of _control flow_, or how a program
gets executed. 

### Conditionals

Perhaps the most common control flow operator is the "conditional" - the `if` operator. In `R`, the `if` operator looks like this: 





::: {.cell}

```{.r .cell-code}
if(TEST){
    # Some code goes here
    # This gets run if `TEST` is true
} else {
    # Some code goes here
    # This gets run if `TEST` if false
}
```
:::





For example




::: {.cell}

```{.r .cell-code}
x <- 3
if(x > 0){
    print("x is positive!")
} else {
    print("x is negative")
}
```

::: {.cell-output .cell-output-stdout}

```
[1] "x is positive!"
```


:::
:::





The element inside the `if` (the test statement) should ideally be Boolean (TRUE/FALSE-ish) but `R` will make a reasonable guess if it isn't. 

Note that you can omit the `else` part and the second set of braces that go with it,
but the first set of braces, immediately after `if()`, should always be there. 





::: {.cell}

```{webr}
x <- 2
if(x %% 2){
    print("x is odd!")
}
```

:::





Change the value of `x` and see what happens.  Next, modify this by
adding an `else` statement to handle the case of odd numbers. 

Note that we're using the `%%` operator here. If you haven't seen it before, 
recall you can get help by typing 

> ?`%%`

in `R`. In this case, `%%` is a `modulo` operator; that is, it is the "remainder"
from division. (Do you see how it works here?)

We'll practice using conditional operators below. 

### Looping

In other 
## Programming Exercises

Write *functions* to perform each of the following tasks. 

1. Write a function that takes in a vector of numbers, calculates the length and maximum value of the vector, and prints that information to the screen in a formatted way.

```
> func_1(c(1, 2, 3, 5, 7))
The largest value in that list of 5 numbers is 7.

> func_1(c(1, 2, 5, 5))
The largest value in that list of 4 numbers is 5.
```

To make your output as attractive as possible, you might want to use the `cat` command instead of the `print` command.

2. Write a program that tests whether its (integer) outputs are leap years. Recall the leap year rules: 

    - A year is a leap year if it is divisible by 4
    - But it is not a leap year if it is divisible by 100
    - Unless it is also divisible by 400
    
```
> leap_year(2023)
FALSE
> leap_year(2024)
TRUE
> leap_year(2100)
FALSE
> leap_year(2000)
TRUE
```

Remember our discussion of the `%\%` operator from class.

3. Write a function to greet your classmates with varying levels of enthusiasm. It should have three optional arguments: 

   a. `name`. The name of the person to greet. Default `"friend"`
   b. `times`. The number of times to repeat the greeting.
   c. `emphasis`. A Boolean (TRUE/FALSE) value indicating whether the greeting should end with an exclamaition point. (Default `FALSE`)

```
> greetings()
Hello, friend
> greetings(name="Michael")
Hello, Michael
> greetings(times=2)
Hello, friend
Hello, friend
> greetings(emphasis=TRUE)
Hello, friend!
> greetings("Michael", 5, TRUE)
Hello, Michael!
Hello, Michael!
Hello, Michael!
Hello, Michael!
Hello, Michael!
```

4. The [Riemann Zeta Function](https://en.wikipedia.org/wiki/Riemann_zeta_function) is a famous function in analytic number theory[^1] defined as
$$\zeta(k) = 1 + \left(\frac{1}{2}\right)^k + \left(\frac{1}{3}\right)^k + \dots = \sum_{i=1}^{\infty} i^{-k} $$
    We cannot implement an infinite series in `R`, but we can get very close by taking a large number of terms in the series (*e.g*, the first 500,000). Implement the zeta function and show that $\zeta(2) = \frac{\pi^2}{6}$

```
> zeta(2)
[1] 1.644932
> zeta(3)
[1] 1.202057
> zeta(4)
[1] 1.082323
> all.equal(zeta(2), pi^2/6, tol=1e-4)
[1] TRUE
```

5. *Hero of Alexandria* developed a method for computing square roots numerically. He showed that by performing the following update repeatedly, $x$ will converge to $\sqrt{n}$:
$$x \leftarrow \frac{1}{2}\left(x + \frac{n}{x}\right)$$
    You can start with any positive $x$, but $n/2$ is a good choice. 

    Implement this method to compute square roots. Use an optional keyword      argument (default value 100) to control how many iterations are performed: 

```
> hero_sqrt(100)
[1] 1.644932
> hero_sqrt(3)^2
[1] 3
> hero_sqrt(3, iter=2)
[1] 1.732143
> hero_sqrt(3000)
[1] 54.77226
```

[^1]: ANL is basically the application of calculus techniques to prove properties of prime numbers: it's a surprisingly powerful approach.
