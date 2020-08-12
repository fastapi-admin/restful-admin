<template>
  <div v-if="data.html" v-html="data.html"></div>
</template>

<script>
export default {
  data() {
    return {
      data: {},
      html: ""
    };
  },
  computed: {
    uri() {
      return this.$route.params.uri.replace(/\./g, "/");
    }
  },
  methods: {
    fetch() {
      this.$http.get(this.uri).then(({data}) => {
        this.data = data;
      });
    }
  },
  created() {
    this.fetch();
  }
};
</script>
