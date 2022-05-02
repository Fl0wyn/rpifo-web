<template>
  <div>
    <v-container fluid>
      <v-row>
        <!-- START : INFORMATION -->
        <v-col cols="12" md="6" lg="4">
          <v-card class="my-6">
            <v-list>
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-subtitle>Hostname</v-list-item-subtitle>
                  <v-list-item-title class="mx-1">
                    <b>{{ content.host }}</b>
                  </v-list-item-title>
                </v-list-item-content>
              </v-list-item>

              <v-list-item v-for="item in content.info" :key="item.title">
                <v-list-item-content>
                  <v-list-item-subtitle>{{ item.title }}</v-list-item-subtitle>
                  <v-list-item-title class="mx-1">
                    {{ item.response }}
                  </v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card>
          <!-- END : INFORMATION -->
          <!-- START : TASKS/CPU -->
          <v-card class="my-6" height="218">
            <h3 class="pa-3">
              <v-icon class="mr-3" color="primary">mdi-gauge-full</v-icon>
              Task / CPU
            </h3>
            <div class="pa-3">
              <span class="text--secondary">Tasks :</span> {{ content.task }}
              <v-divider dark class="ma-3"></v-divider>
              <v-progress-circular
                rotate="-90"
                class="mx-3"
                :value="(cpu.split(' ')[0] / 5) * 100"
                :size="cpu_size"
                :width="cpu_width"
                :color="color"
              >
                <span style="color: black"> {{ cpu.split(" ")[0] }} </span>
              </v-progress-circular>
              <v-progress-circular
                rotate="-90"
                class="mx-3"
                :value="(cpu.split(' ')[1] / 5) * 100"
                :size="cpu_size"
                :width="cpu_width"
                :color="color"
              >
                <span style="color: black"> {{ cpu.split(" ")[1] }} </span>
              </v-progress-circular>
              <v-progress-circular
                rotate="-90"
                class="mx-3"
                :value="(cpu.split(' ')[2] / 5) * 100"
                :size="cpu_size"
                :width="cpu_width"
                :color="color"
              >
                <span style="color: black"> {{ cpu.split(" ")[2] }} </span>
              </v-progress-circular>
            </div>
          </v-card>
        </v-col>
        <!-- END : TASKS/CPU -->
        <!-- START : TEMPERATURE -->
        <v-col cols="12" md="6" lg="3">
          <v-card class="my-6">
            <h3 class="pa-3">
              <v-icon class="mr-3" color="primary"
                >mdi-thermometer-lines</v-icon
              >
              Temperature
            </h3>
            <div class="pa-3">
              <vue-svg-gauge
                :start-angle="-90"
                :end-angle="90"
                :value="parseInt(content.temp)"
                :separator-step="25"
                :separator-thickness="1"
                :inner-radius="70"
                :min="0"
                :max="100"
                :gauge-color="color"
                :scale-interval="5"
              >
                <div class="gaugePlace">{{ content.temp }}°</div>
              </vue-svg-gauge>
              <span class="mx-4 text--disabled text-center justify-center"
                >0°</span
              >
              <span class="mx-1 text--disabled float-right">100°</span>
            </div>
          </v-card>
          <!-- END : TEMPERATURE -->
          <v-card class="my-6">
            <div class="pa-3">
              <!-- STAR : MEMORY -->
              <h3>
                <v-icon class="mr-3" color="primary">mdi-memory</v-icon>
                Memory
              </h3>
              <span :class="classtitle"
                >Total (<b>{{ convertKo(mem.split(" ")[0]) }}</b
                >) — Free (<b>{{ convertKo(mem.split(" ")[2]) }}</b
                >)
              </span>

              <v-progress-linear
                :value="(mem.split(' ')[1] / mem.split(' ')[0]) * 100"
                :class="classprogress"
                :color="color"
                :rounded="rounded"
                :height="height"
                >{{
                  convertKo(mem.split(" ")[1]) +
                  " (" +
                  parseFloat(
                    (mem.split(" ")[1] / mem.split(" ")[0]) * 100
                  ).toFixed(1) +
                  "%)"
                }}</v-progress-linear
              >
              <!-- END : MEMORY -->
              <v-divider dark class="ma-5"></v-divider>
              <!-- STAR : DISQUE -->
              <h3>
                <v-icon class="mr-3" color="primary">mdi-sd</v-icon>
                Disque
              </h3>
              <span :class="classtitle"
                >Total (<b>{{ convertKo(df.split(" ")[0]) }}</b
                >) — Free (<b>{{ convertKo(df.split(" ")[2]) }}</b
                >)
              </span>

              <v-progress-linear
                :value="(df.split(' ')[1] / df.split(' ')[0]) * 100"
                :class="classprogress"
                :color="color"
                :rounded="rounded"
                :height="height"
                >{{
                  convertKo(df.split(" ")[1]) +
                  " (" +
                  parseFloat(
                    (df.split(" ")[1] / df.split(" ")[0]) * 100
                  ).toFixed(1) +
                  "%)"
                }}</v-progress-linear
              >
              <!-- END : DISQUE -->
              <v-divider dark class="ma-5"></v-divider>
              <!-- STAR : SWAP -->
              <h3>
                <v-icon class="mr-3" color="primary"
                  >mdi-swap-horizontal-bold</v-icon
                >
                Swap
              </h3>
              <span :class="classtitle"
                >Total (<b>{{ convertKo(swap.split(" ")[0]) }}</b
                >) — Free (<b>{{ convertKo(swap.split(" ")[2]) }}</b
                >)
              </span>

              <v-progress-linear
                :value="(swap.split(' ')[1] / swap.split(' ')[0]) * 100"
                :class="classprogress"
                :color="color"
                :rounded="rounded"
                :height="height"
                >{{
                  convertKo(swap.split(" ")[1]) +
                  " (" +
                  parseFloat(
                    (swap.split(" ")[1] / swap.split(" ")[0]) * 100
                  ).toFixed(1) +
                  "%)"
                }}</v-progress-linear
              >
              <!-- END : SWAP -->
            </div>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import axios from "axios";
import { convertKo } from "../functions";

export default {
  data() {
    return {
      content: [],
      color: "#1976d2",

      cpu_size: "80",
      cpu_width: "10",

      cpu: "",
      mem: "",
      df: "",
      swap: "",

      classtitle: "ml-11 subtitle-2",
      classprogress: "my-1 rounded-xl",
      rounded: true,
      height: "25",
    };
  },
  methods: {
    convertKo,
  },
  mounted() {
    axios.get("../result.json").then((r) => {
      var rpi = (this.content = r.data);
      document.title = "Rpifo - " + rpi.host;
      this.cpu = rpi.cpu;
      this.mem = rpi.mem;
      this.df = rpi.df;
      this.swap = rpi.swap;
    });

    window.setInterval(() => {
      axios.get("../result.json").then((r) => {
        var rpi = (this.content = r.data);
        this.cpu = rpi.cpu;
        this.mem = rpi.mem;
        this.df = rpi.df;
        this.swap = rpi.swap;
      });
    }, 60000);
  },
};
</script>

<style>
.v-progress-linear__background {
  opacity: 0.8 !important;
  background-color: hsla(0, 0%, 62%, 0.4) !important;
  border-color: hsla(0, 0%, 62%, 0.4) !important;
}

.gaugePlace {
  text-align: center !important;
  margin: 0;
  position: absolute;
  top: 70%;
  width: 100%;
}
</style>