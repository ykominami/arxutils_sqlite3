# -*- coding: utf-8 -*-
require 'pathname'
module Arxutils_Sqlite3
  TOP_DIR = Pathname(__FILE__).parent.parent
  TEMPLATE_DIR = TOP_DIR + 'template'
  TEMPLATE_RELATION_DIR = TEMPLATE_DIR.join('relation')
  TEMPLATE_CONFIG_DIR = TEMPLATE_DIR.join('config')
  CONFIG_DIR = 'config'
end
