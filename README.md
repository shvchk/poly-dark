## Poly dark GRUB theme

Supported languages: Chinese (simplified), Chinese (traditional), English, French, German, Hungarian, Italian, Korean, Latvian, Norwegian, Polish, Portuguese, Russian, Rusyn, Spanish, Turkish, Ukrainian

![](https://i.imgur.com/OHGyR2N.gif)

Screenshot is intentionally low res to fit GitHub UI. See also: [1280×720](https://i.imgur.com/iKtkLr4.png), [1920×1080](https://i.imgur.com/faGEmp5.png)

---


### Installation / update

1. **Secure way:**

    - Download install script:

      ```sh
      wget -P /tmp https://github.com/shvchk/poly-dark/raw/master/install.sh
      ```

    - Review it at `/tmp/install.sh`

    - Run it:

      ```sh
      bash /tmp/install.sh
      ```

2. **Easier, less secure way** — just download and run install script:

    ```sh
    wget -O - https://github.com/shvchk/poly-dark/raw/master/install.sh | bash
    ```

<br>

You can use `--lang` option to select language and disable interactive language selection, e.g.:

```sh
bash /tmp/install.sh --lang German
```

or

```sh
wget -O- https://github.com/shvchk/poly-dark/raw/master/install.sh | bash -s -- --lang Korean
```

Full list of languages see in `INSTALLER_LANGS` variable in [install.sh](install.sh)

---


### See also

- [Poly light GRUB theme](https://github.com/shvchk/poly-light)
- [Fallout GRUB theme](https://github.com/shvchk/fallout-grub-theme)
