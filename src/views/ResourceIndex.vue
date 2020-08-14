<template>
  <div>
    <custom-table></custom-table>
  </div>
</template>

<script>
import CustomTable from "./CustomTable";

export default {
  name: "resource-index",
  components: {
    CustomTable
  },
  data() {
    return {};
  },
  computed: {
    resource() {
      return this.$route.params.resource;
    }
  },
  methods: {},
  created() {
  }
};
</script>
