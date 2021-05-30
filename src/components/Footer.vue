<template>
  <v-footer padless>
    <v-col class="text-center text--secondary" cols="12">
      v{{ version }} © {{ new Date().getFullYear() }} —
      <strong
        ><a
          class="text--secondary"
          href="https://github.com/debmus/rpifo-web"
          target="_blank"
          rel="noopener noreferrer"
          >Rpifo</a
        ></strong
      >
    </v-col>
  </v-footer>
</template>

<script>
export default {
  data() {
    return {
      version: "",
    };
  },
  mounted() {
    fetch("../VERSION")
      .then((r) => r.text())
      .then((t) => {
        this.version = t;
      });
  },
};
</script>
