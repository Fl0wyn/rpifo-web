<template>
  <div>
    <v-app-bar elevation='1'>
      <v-icon large color="primary">mdi-raspberry-pi</v-icon>
      <v-toolbar-title class="mx-4"> Rpifo </v-toolbar-title>
      <v-spacer></v-spacer>
<!--       <v-toolbar-title>
        
      </v-toolbar-title> -->
    </v-app-bar>
  </div>
</template>

<script>
export default {
  data() {
    return {
      heure: "",
    };
  },
  mounted() {
    var today = new Date();
    return (
      (this.heure =
        today.toLocaleDateString() + " - " + today.toLocaleTimeString()),
      window.setInterval(() => {
        var today = new Date();
        return (this.heure =
          today.toLocaleDateString() + " - " + today.toLocaleTimeString());
      }, 1000)
    );
  },
};
</script>
