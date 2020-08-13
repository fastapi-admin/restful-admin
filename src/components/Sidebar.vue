<template>
  <div class="pt-3 pl-3">
    <div class="text-center top">
      <a :href="site.url" target="_blank" v-if="site.logo" v-show="!collapsed">
        <b-img class="site-logo" :src="site.logo" fluid/>
      </a>

      <b-img v-if="auth.user.avatar" rounded="circle" :src="auth.user.avatar" height="70" blank-color="#777"
             alt="avatar" class="m-2"/>
      <div class="my-3" v-if="site.sidebar_userinfo !== false" v-show="!collapsed">
        <h5 style="letter-spacing:2px">{{ site.name }}</h5>
        <template v-if="auth.user">
          <b-badge class="text-uppercase mr-1" v-if="auth.user.badge">{{ auth.user.badge }}</b-badge>
          <span>{{ auth.user.username }}</span>
          <i class="reset-pass fa fa-key fa-fw" v-b-modal.modal-prevent-closing></i>
          <div>
            <b-modal
              id="modal-prevent-closing"
              ref="modal"
              :title="$t('texts.update_password')"
              @ok="handleOk"
            >
              <form ref="form" @submit.stop.prevent="handleSubmit">
                <b-form-group
                  :label="$t('fields.old_password')"
                  label-for="old-password-input"
                  :state="old_password_state"
                >
                  <b-form-input
                    id="old-password-input"
                    v-model="form.old_password"
                    required
                    type="password"
                    :state="old_password_state"
                  ></b-form-input>
                </b-form-group>
                <b-form-group
                  :label="$t('fields.new_password')"
                  label-for="new-password-input"
                  :state="new_password_state"
                >
                  <b-form-input
                    id="new-password-input"
                    v-model="form.new_password"
                    type="password"
                    :state="new_password_state"
                    required
                  ></b-form-input>
                </b-form-group>
                <b-form-group
                  :label="$t('fields.confirm_password')"
                  label-for="confirm-password-input"
                  :state="confirm_password_state"
                >
                  <b-form-input
                    id="confirm-password-input"
                    v-model="form.confirm_password"
                    type="password"
                    :state="confirm_password_state"
                    required
                  ></b-form-input>
                </b-form-group>
              </form>
            </b-modal>
          </div>
        </template>
      </div>
      <div v-else></div>

      <locale-switcher v-show="!collapsed"></locale-switcher>
      <theme-switcher v-show="!collapsed"></theme-switcher>
    </div>
    <div slot="header"></div>
    <b-nav pills class="sidebar-nav" vertical>
      <template v-for="(item, index) in site.menus">
        <template v-if="!(item.title && site.menus[index+1].title)">
          <b-nav-text v-if="item.title" :key="index">
            <small class="text-muted">
              <b>{{ item.name }}</b>
            </small>
          </b-nav-text>
          <b-nav vertical v-else-if="item.children" :key="index">
            <b-nav-item :to="child.url" :key="child.name" v-for="child in item.children">
              <i class="mr-1" :class="child.icon"></i>
              <span>{{ child.name }}</span>
              <b-badge v-bind="child.badge" v-if="child.badge">{{ child.badge.text }}</b-badge>
            </b-nav-item>
          </b-nav>
          <b-nav-item :active="$route.path === item.url" target="_blank" :href="item.url" v-else-if="item.external"
                      :key="index">
            <i :class="{'mr-2': !collapsed, [item.icon]: true}"></i>
            <span v-show="!collapsed">{{ item.name }}</span>
            <b-badge v-bind="item.badge" v-if="item.badge">{{ item.badge.text }}</b-badge>
          </b-nav-item>
          <b-nav-item :active="$route.path === item.url" :to="item.url" v-else :key="index">
            <i :class="{'mr-2': !collapsed, [item.icon]: true}"></i>
            <span v-show="!collapsed">{{ item.name }}</span>
            <b-badge v-bind="item.badge" v-if="item.badge">{{ item.badge.text }}</b-badge>
          </b-nav-item>
        </template>
      </template>
      <slot></slot>
    </b-nav>
    <p></p>
  </div>
</template>
<script>
import ThemeSwitcher from "./ThemeSwitcher";
import LocaleSwitcher from "./LocaleSwitcher";

import {mapState} from "vuex";

export default {
  name: "sidebar",
  props: {
    collapsed: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      form: {
        confirm_password: null,
        old_password: null,
        new_password: null,
      },
      confirm_password_state: null,
      old_password_state: null,
      new_password_state: null,
    };
  },

  computed: {
    ...mapState(["auth", "site"]),
    menus() {
      const menus = [];
      const titleIndices = [];
      this.site.menus.forEach((v, k) => {
        v.title && titleIndices.push(parseInt(k));
      });
      for (let i in titleIndices) {
        menus.push({
          name: this.site.menus[titleIndices[i]].name,
          children: this.site.menus.slice(
            titleIndices[i] + 1,
            titleIndices[parseInt(i) + 1]
          )
        });
      }
      return menus;
    }
  },
  components: {LocaleSwitcher, ThemeSwitcher},
  methods: {
    toggle(item) {
      this.$set(item, "open", !item.open);
    },
    handleSubmit() {
      // Exit when the form isn't valid
      if (!this.checkFormValidity()) {
        return
      }
      this.$http.put('password', this.form)
        .then(({data}) => {
          this.$snotify.success(this.$t("messages.succeed"));
          this.$emit("success", data);
        })
        .catch(({data, status}) => {
          if (status == 422) {
            this.errors = data.message;
          }
        });
      // Hide the modal manually
      this.$nextTick(() => {
        this.$bvModal.hide('modal-prevent-closing')
      })
    },
    checkFormValidity() {
      const valid = this.$refs.form.checkValidity()
      this.old_password_state = valid
      this.new_password_state = valid
      this.confirm_password_state = valid
      if (this.form.new_password !== this.form.confirm_password) {
        this.confirm_password_state = false
        return false
      }
      return valid
    },
    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault()
      // Trigger submit handler
      this.handleSubmit()
    },
  }
};
</script>

<style lang="scss">
.site-logo {
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
}

.sidebar-nav {
  .nav-item a {
    color: #666;
    padding: 0.7rem 1rem;
  }
}

.sidebar-nav .nav-item:hover {
  background: #f6f6f6;
}

.reset-pass {
  margin-left: 10px;
  cursor: pointer;
}
</style>
