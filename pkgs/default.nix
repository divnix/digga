final: prev: {
  devosOptionsDoc = (prev.lib.dev.evalFlakeArgs { args = {}; }).config.genDoc prev;
}
