{ fetchurl }:
let
  nugetUrlBase = "https://www.nuget.org/api/v2/package";
  fetchNuGet = { name, version, sha256 }:
    fetchurl {
      inherit sha256;
      url = "${nugetUrlBase}/${name}/${version}";
    };
in [

  (fetchNuGet {
    name = "Microsoft.AspNetCore.App.Runtime.linux-x64";
    version = "3.1.2";
    sha256 = "19wfh9yg4n2khbl7pvf6ngx95m5p8lw4l9y935pv7nh4xgwk02p9";
  })
  (fetchNuGet {
    name = "Microsoft.NETCore.App.Runtime.linux-x64";
    version = "3.1.2";
    sha256 = "0a332ia5pabnz7mdfc99a5hlc7drnwzlc7cj9b5c3an6dq636p66";
  })
  (fetchNuGet {
    name = "System.IO.Pipelines";
    version = "4.5.0";
    sha256 = "0qllpzgws17xc9dr94p1k32rnicq7ky55ssxrc11k3gr7waqy3p9";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Connections.Abstractions";
    version = "2.1.3";
    sha256 = "1pfpcg92lb7g7hi8w5vpqz01gyi0vvj0071sgkm6b97sqy10ss15";
  })
  (fetchNuGet {
    name = "System.Text.Encoding";
    version = "4.0.11";
    sha256 = "1dyqv0hijg265dwxg6l7aiv74102d6xjiwplh2ar1ly6xfaa4iiw";
  })
  (fetchNuGet {
    name =
      "runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.Apple";
    version = "4.3.0";
    sha256 = "10yc8jdrwgcl44b4g93f1ds76b176bajd3zqi2faf5rvh1vy9smi";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Http.Features";
    version = "2.1.1";
    sha256 = "0vifha5wfynpgg4kvdmbqcgn6ngkxkkdmx1qnvlphmjx0iw7sw3d";
  })
  (fetchNuGet {
    name = "System.Security.Cryptography.Cng";
    version = "4.5.0";
    sha256 = "1pm4ykbcz48f1hdmwpia432ha6qbb9kbrxrrp7cg3m8q8xn52ngn";
  })
  (fetchNuGet {
    name = "System.Threading.Tasks.Extensions";
    version = "4.5.1";
    sha256 = "1ikrplvw4m6pzjbq3bfbpr572n4i9mni577zvmrkaygvx85q3myw";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Server.Kestrel.Transport.Abstractions";
    version = "2.1.3";
    sha256 = "0lnbbbs5lx2x414smmfinjlc5xqrbn0ps5m3nlgw6w5jajmlikkd";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Authentication.Abstractions";
    version = "2.1.1";
    sha256 = "1y90jx0xbmq9hwhvvyy6hbavvdffn0in71qfgq7gw2f92dg91j1r";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.FileSystemGlobbing";
    version = "2.1.1";
    sha256 = "039w2gfvapdy5a1gl1bkajr6glngp29j895cgysy8132vg80jgwb";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.FileProviders.Abstractions";
    version = "2.1.1";
    sha256 = "1shldpcczkc7rkxq0xd4zxm1r047bswy8nj1vx27aisni6nyqxys";
  })
  (fetchNuGet {
    name = "Microsoft.Net.Http.Headers";
    version = "2.1.1";
    sha256 = "06q4xmxj25ry7gkl51zi7vh2957k9s49vdrlgfy03w9rqk81vnld";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Hosting.Server.Abstractions";
    version = "2.1.1";
    sha256 = "0zldzvhh7xraps3gg47anva3dm3gssynw3k3gazjvqwb4gblsw6p";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Primitives";
    version = "2.1.1";
    sha256 = "033rkqdffybq5prhc7nn6v68zij393n00s5a82yf2n86whwvdfwx";
  })
  (fetchNuGet {
    name = "prometheus-net";
    version = "3.1.2";
    sha256 = "1jyxvl9cqxvb71mpaglw8aks27i69hg7yzrdwsjc182nmmhh1p03";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Mvc.NewtonsoftJson";
    version = "3.0.0";
    sha256 = "09l5a4whdpqrx3jmpq4ff141i2wx1pjxj1g8g0r18yghmd664n0b";
  })
  (fetchNuGet {
    name = "morelinq";
    version = "3.1.1";
    sha256 = "0cr72x3ks9rw5sf3w0bqa4k2lsjk0cnhlny7xkr5h1vhc16fd85c";
  })
  (fetchNuGet {
    name = "Polly";
    version = "7.1.0";
    sha256 = "15x7gqndxrji55lvvb3173amhsqai4k10rd0f99416vc48cpsymf";
  })
  (fetchNuGet {
    name = "FluentValidation.ValidatorAttribute";
    version = "8.4.0";
    sha256 = "1rh2lbylhbk70rbdr3002abh9lpnpgyag31qggw657lg7g354m42";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.Json";
    version = "2.2.0";
    sha256 = "18cmrvlhc71bxplldbgwfjg29qflcaf4rrg2avp4g03fqwma6vvc";
  })
  (fetchNuGet {
    name = "NLog.Extensions.Logging";
    version = "1.5.0";
    sha256 = "0q60h9qafn0wiwmy2krxhyjk8jhnzixzfsmr497lvdlfliam4bc3";
  })
  (fetchNuGet {
    name = "JetBrains.Annotations";
    version = "2019.1.1";
    sha256 = "053j96chwnig7sf4ji970gra7d3s7dzdnjypqsymaz7bxlna3n6i";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Caching.Memory";
    version = "2.2.0";
    sha256 = "0bzrsn5vas86w66bd04xilnlb21nx4l6lz7d3acvy6y8ir2vb5dv";
  })
  (fetchNuGet {
    name = "McMaster.Extensions.CommandLineUtils";
    version = "2.3.4";
    sha256 = "0zh8zwr2nill3vxrg88rkgs2wkqawnnnhwj69wh8cyrbchjn4lhm";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Options.ConfigurationExtensions";
    version = "2.2.0";
    sha256 = "0w95rpxl0fzcz7rp8zabv3c9bvkj9ma2mj1hrx9nipsc4dnqp4jd";
  })
  (fetchNuGet {
    name = "prometheus-net.AspNetCore";
    version = "3.1.2";
    sha256 = "0p38d06q41ppkmb90izlc0livdlmaf23mhiwl8wspvxjjh3zx510";
  })
  (fetchNuGet {
    name = "FluentValidation";
    version = "8.4.0";
    sha256 = "1i6axjyhxpxrlm02kaprr4hw38i4xadwdj946xqh5dkfdmjqxa5i";
  })
  (fetchNuGet {
    name = "Autofac";
    version = "4.9.2";
    sha256 = "13bvrhvncmg6y679qi16vkhbj9xl1d41gczkcfvim6b2xky2mjf7";
  })
  (fetchNuGet {
    name = "Npgsql";
    version = "4.0.6";
    sha256 = "1mjpz5001zf5fsqcmi1qii0gkdjza4p9px06ksg73qq94611f1x5";
  })
  (fetchNuGet {
    name = "Newtonsoft.Json";
    version = "12.0.2";
    sha256 = "0w2fbji1smd2y7x25qqibf1qrznmv4s6s0jvrbvr6alb7mfyqvh5";
  })
  (fetchNuGet {
    name = "NLog";
    version = "4.6.3";
    sha256 = "05zpcqsv6j1kspwb5f4bb884j4kvbr9rfsl8gn77n4r8kp3xzvy9";
  })
  (fetchNuGet {
    name = "AspNetCoreRateLimit";
    version = "3.0.4";
    sha256 = "01d1ljayng72v4kk81kzc29gc6sdll5pz49fkcwm4g7ygs5mvnd4";
  })
  (fetchNuGet {
    name = "NBitcoin.Zcash";
    version = "3.0.0";
    sha256 = "0ycg7r4ibnkdqcbc7mx3z4rlvclp6jsx2d1h8vpkj699s2a29dhs";
  })
  (fetchNuGet {
    name = "AutoMapper";
    version = "8.1.0";
    sha256 = "0jhlfzkj2r8dssann7x71pmhkq7l7rqzpdcd3q4wr2m9jvxz8fyx";
  })
  (fetchNuGet {
    name = "System.Reactive";
    version = "4.1.5";
    sha256 = "0cb599cz3sm65d5b9y0hrmy85paxsq2755adcncn51kql7q4hp8s";
  })
  (fetchNuGet {
    name = "System.Diagnostics.Process";
    version = "4.3.0";
    sha256 = "0g4prsbkygq8m21naqmcp70f24a1ksyix3dihb1r1f71lpi3cfj7";
  })
  (fetchNuGet {
    name = "protobuf-net";
    version = "2.4.0";
    sha256 = "106lxm9afga7ihlknyy7mlfplyq40mrndksqrsn8ia2a47fbqqld";
  })
  (fetchNuGet {
    name = "Dapper";
    version = "1.60.6";
    sha256 = "091jczp3qvfwkkql6zvx0xb75c7xrqxnya5z3j90wxdbkpnhdkqj";
  })
  (fetchNuGet {
    name = "NBitcoin";
    version = "4.1.2.22";
    sha256 = "01fs76x6kpa5i98bq32217aqmg616b4g53p6chjsb92ibf5al8fd";
  })
  (fetchNuGet {
    name = "MailKit";
    version = "2.1.4";
    sha256 = "1j0ywdf2jafvdnbcnnk3cif59pj8kab0a0dfjxx5h5q5avilng2l";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.JsonPatch";
    version = "3.0.0";
    sha256 = "19hiid0y5mpf64bhfi0f40bq3vdgf7hfja7m71ginzq81ycg313z";
  })
  (fetchNuGet {
    name = "Newtonsoft.Json.Bson";
    version = "1.0.2";
    sha256 = "0c27bhy9x3c2n26inq32kmp6drpm71n6mqnmcr19wrlcaihglj35";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration";
    version = "2.2.0";
    sha256 = "02250qrs3jqqbggfvd0mkim82817f79x6jh8fx2i7r58d0m66qkl";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.FileExtensions";
    version = "2.2.0";
    sha256 = "0bwk1kh6q259nmnly90j5rbbzi9w5gigq5vyjr31c1br4j8cjmqd";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging";
    version = "2.1.0";
    sha256 = "0dii8i7s6libfnspz2xb96ayagb4rwqj2kmr162vndivr9rmbm06";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.DependencyInjection.Abstractions";
    version = "2.2.0";
    sha256 = "1jyzfdr9651h3x6pxwhpfbb9mysfh8f8z1jvy4g117h9790r9zx5";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Caching.Abstractions";
    version = "2.2.0";
    sha256 = "0hhxc5dp52faha1bdqw0k426zicsv6x1kfqi30m9agr0b2hixj52";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Options";
    version = "2.2.0";
    sha256 = "1b20yh03fg4nmmi3vlf6gf13vrdkmklshfzl3ijygcs4c2hly6v0";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.Binder";
    version = "2.2.0";
    sha256 = "10qyjdkymdmag3r807kvbnwag4j3nz65i4cwikbd77jjvz92ya3j";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.Abstractions";
    version = "2.2.0";
    sha256 = "1fv5277hyhfqmc0gqszyqb1ilwnijm8kc9606yia6hwr8pxyg674";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging";
    version = "2.2.0";
    sha256 = "0bx3ljyvvcbikradq2h583rl72h8bxdz33aghk026cxzpv2mm3wm";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Http";
    version = "2.2.2";
    sha256 = "09mgjvpqdyylz9dbngql9arx46lfkiczjdf7aqr9asd5vjqlv2c8";
  })
  (fetchNuGet {
    name = "System.ComponentModel.Annotations";
    version = "4.4.1";
    sha256 = "1d46yx6h36bssqyshq44qxx0fsx43bjf09zrlbvqfigacfsp9mph";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore";
    version = "2.1.7";
    sha256 = "10xkypd0dyaxliz0x5gfsbsq2qdvzcxrf3mwfql00qk8sc1315pf";
  })
  (fetchNuGet {
    name = "System.Memory";
    version = "4.5.2";
    sha256 = "1g24dwqfcmf4gpbgbhaw1j49xmpsz389l6bw2xxbsmnzvsf860ld";
  })
  (fetchNuGet {
    name = "System.Runtime.CompilerServices.Unsafe";
    version = "4.5.2";
    sha256 = "1vz4275fjij8inf31np78hw50al8nqkngk04p3xv5n4fcmf1grgi";
  })
  (fetchNuGet {
    name = "System.Threading.Tasks.Extensions";
    version = "4.5.2";
    sha256 = "1sh63dz0dymqcwmprp0nadm77b83vmm7lyllpv578c397bslb8hj";
  })
  (fetchNuGet {
    name = "System.ValueTuple";
    version = "4.5.0";
    sha256 = "00k8ja51d0f9wrq4vv5z2jhq8hy31kac2rg0rv06prylcybzl8cy";
  })
  (fetchNuGet {
    name = "Portable.BouncyCastle";
    version = "1.8.2";
    sha256 = "0xqc8q40lr4r7ahsmzpa1q0jagp12abb6rsj80p37q34hsv5284q";
  })
  (fetchNuGet {
    name = "Microsoft.CSharp";
    version = "4.5.0";
    sha256 = "01i28nvzccxbqmiz217fxs6hnjwmd5fafs37rd49a6qp53y6623l";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.Abstractions";
    version = "2.1.0";
    sha256 = "03gzlr3z9j1xnr1k6y91zgxpz3pj27i3zsvjwj7i8jqnlqmk7pxd";
  })
  (fetchNuGet {
    name = "System.Reflection.Emit";
    version = "4.3.0";
    sha256 = "11f8y3qfysfcrscjpjym9msk7lsfxkk4fmz9qq95kn3jd0769f74";
  })
  (fetchNuGet {
    name = "System.Runtime.InteropServices.WindowsRuntime";
    version = "4.3.0";
    sha256 = "0bpsy91yqm2ryp5y9li8p6yh4yrxcvg9zvm569ifw25rpy67bgp9";
  })
  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "1.1.0";
    sha256 = "08vh1r12g6ykjygq5d3vq09zylgb84l63k49jc4v8faw9g93iqqm";
  })
  (fetchNuGet {
    name = "System.IO.FileSystem.Primitives";
    version = "4.3.0";
    sha256 = "0j6ndgglcf4brg2lz4wzsh1av1gh8xrzdsn9f0yznskhqn1xzj9c";
  })
  (fetchNuGet {
    name = "runtime.native.System";
    version = "4.3.0";
    sha256 = "15hgf6zaq9b8br2wi1i3x0zvmk410nlmsmva9p0bbg73v6hml5k4";
  })
  (fetchNuGet {
    name = "System.Runtime.Handles";
    version = "4.3.0";
    sha256 = "0sw2gfj2xr7sw9qjn0j3l9yw07x73lcs97p8xfc9w1x9h5g5m7i8";
  })
  (fetchNuGet {
    name = "Microsoft.Win32.Primitives";
    version = "4.3.0";
    sha256 = "0j0c1wj4ndj21zsgivsc24whiya605603kxrbiw6wkfdync464wq";
  })
  (fetchNuGet {
    name = "System.Diagnostics.Debug";
    version = "4.3.0";
    sha256 = "00yjlf19wjydyr6cfviaph3vsjzg3d5nvnya26i2fvfg53sknh3y";
  })
  (fetchNuGet {
    name = "System.Threading.ThreadPool";
    version = "4.3.0";
    sha256 = "027s1f4sbx0y1xqw2irqn6x161lzj8qwvnh2gn78ciiczdv10vf1";
  })
  (fetchNuGet {
    name = "System.IO.FileSystem";
    version = "4.3.0";
    sha256 = "0z2dfrbra9i6y16mm9v1v6k47f0fm617vlb7s5iybjjsz6g1ilmw";
  })
  (fetchNuGet {
    name = "Microsoft.Win32.Registry";
    version = "4.3.0";
    sha256 = "1gxyzxam8163vk1kb6xzxjj4iwspjsz9zhgn1w9rjzciphaz0ig7";
  })
  (fetchNuGet {
    name = "System.Threading.Thread";
    version = "4.3.0";
    sha256 = "0y2xiwdfcph7znm2ysxanrhbqqss6a3shi1z3c779pj2s523mjx4";
  })
  (fetchNuGet {
    name = "System.Collections";
    version = "4.3.0";
    sha256 = "19r4y64dqyrq6k4706dnyhhw7fs24kpp3awak7whzss39dakpxk9";
  })
  (fetchNuGet {
    name = "System.Threading.Tasks";
    version = "4.3.0";
    sha256 = "134z3v9abw3a6jsw17xl3f6hqjpak5l682k2vz39spj4kmydg6k7";
  })
  (fetchNuGet {
    name = "System.Text.Encoding.Extensions";
    version = "4.3.0";
    sha256 = "11q1y8hh5hrp5a3kw25cb6l00v5l5dvirkz8jr3sq00h1xgcgrxy";
  })
  (fetchNuGet {
    name = "System.Globalization";
    version = "4.3.0";
    sha256 = "1cp68vv683n6ic2zqh2s1fn4c2sd87g5hpp6l4d4nj4536jz98ki";
  })
  (fetchNuGet {
    name = "System.Text.Encoding";
    version = "4.3.0";
    sha256 = "1f04lkir4iladpp51sdgmis9dj4y8v08cka0mbmsy0frc9a4gjqr";
  })
  (fetchNuGet {
    name = "System.Threading";
    version = "4.3.0";
    sha256 = "0rw9wfamvhayp5zh3j7p1yfmx9b5khbf4q50d8k5rk993rskfd34";
  })
  (fetchNuGet {
    name = "System.Resources.ResourceManager";
    version = "4.3.0";
    sha256 = "0sjqlzsryb0mg4y4xzf35xi523s4is4hz9q4qgdvlvgivl7qxn49";
  })
  (fetchNuGet {
    name = "System.IO";
    version = "4.3.0";
    sha256 = "05l9qdrzhm4s5dixmx68kxwif4l99ll5gqmh7rqgw554fx0agv5f";
  })
  (fetchNuGet {
    name = "System.Runtime.Extensions";
    version = "4.3.0";
    sha256 = "1ykp3dnhwvm48nap8q23893hagf665k0kn3cbgsqpwzbijdcgc60";
  })
  (fetchNuGet {
    name = "System.Runtime.InteropServices";
    version = "4.3.0";
    sha256 = "00hywrn4g7hva1b2qri2s6rabzwgxnbpw9zfxmz28z09cpwwgh7j";
  })
  (fetchNuGet {
    name = "System.Runtime";
    version = "4.3.0";
    sha256 = "066ixvgbf2c929kgknshcxqj6539ax7b9m570cp8n179cpfkapz7";
  })
  (fetchNuGet {
    name = "System.ServiceModel.Primitives";
    version = "4.5.3";
    sha256 = "1v90pci049cn44y0km885k1vrilhb34w6q2zva4y6f3ay84klrih";
  })
  (fetchNuGet {
    name = "System.Reflection.TypeExtensions";
    version = "4.4.0";
    sha256 = "0n9r1w4lp2zmadyqkgp4sk9wy90sj4ygq4dh7kzamx26i9biys5h";
  })
  (fetchNuGet {
    name = "System.Reflection.Emit.Lightweight";
    version = "4.3.0";
    sha256 = "0ql7lcakycrvzgi9kxz1b3lljd990az1x6c4jsiwcacrvimpib5c";
  })
  (fetchNuGet {
    name = "System.Data.SqlClient";
    version = "4.4.0";
    sha256 = "1djh6i8s9s035glf2kg3fnlxkj36gf6327w5q44229nw48y6x8kh";
  })
  (fetchNuGet {
    name = "System.Buffers";
    version = "4.5.0";
    sha256 = "1ywfqn4md6g3iilpxjn5dsr0f5lx6z0yvhqp4pgjcamygg73cz2c";
  })
  (fetchNuGet {
    name = "System.Net.Requests";
    version = "4.3.0";
    sha256 = "0pcznmwqqk0qzp0gf4g4xw7arhb0q8v9cbzh3v8h8qp6rjcr339a";
  })
  (fetchNuGet {
    name = "System.Net.Http";
    version = "4.3.3";
    sha256 = "02a8r520sc6zwrmls9n80j8f22lvx7p3nidjp4w7nh6my3d4lq77";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging.Abstractions";
    version = "1.0.2";
    sha256 = "08hxkx80rsq45r66nnf9r35yas6f7iyzki2sl7874nb0mmdmcz4c";
  })
  (fetchNuGet {
    name = "NETStandard.Library";
    version = "1.6.1";
    sha256 = "1z70wvsx2d847a2cjfii7b83pjfs34q05gb037fdjikv5kbagml8";
  })
  (fetchNuGet {
    name = "System.Globalization.Extensions";
    version = "4.3.0";
    sha256 = "02a5zfxavhv3jd437bsncbhd2fp1zv4gxzakp1an9l6kdq1mcqls";
  })
  (fetchNuGet {
    name = "System.Runtime.Serialization.Primitives";
    version = "4.3.0";
    sha256 = "01vv2p8h4hsz217xxs0rixvb7f2xzbh6wv1gzbfykcbfrza6dvnf";
  })
  (fetchNuGet {
    name = "System.Reflection.TypeExtensions";
    version = "4.3.0";
    sha256 = "0y2ssg08d817p0vdag98vn238gyrrynjdj4181hdg780sif3ykp1";
  })
  (fetchNuGet {
    name = "System.Net.NetworkInformation";
    version = "4.3.0";
    sha256 = "1w10xqq3d5xqipp5403y5ndq7iggq19jimrd6gp5rghp1qg8rlbg";
  })
  (fetchNuGet {
    name = "System.Text.Encoding.CodePages";
    version = "4.3.0";
    sha256 = "0lgxg1gn7pg7j0f942pfdc9q7wamzxsgq3ng248ikdasxz0iadkv";
  })
  (fetchNuGet {
    name = "System.Net.NameResolution";
    version = "4.3.0";
    sha256 = "15r75pwc0rm3vvwsn8rvm2krf929mjfwliv0mpicjnii24470rkq";
  })
  (fetchNuGet {
    name = "System.Net.Security";
    version = "4.3.0";
    sha256 = "1aa5igz31ivk6kpgsrwck3jccab7wd88wr52lddmgypmbh9mmf87";
  })
  (fetchNuGet {
    name = "System.Data.Common";
    version = "4.3.0";
    sha256 = "12cl7vy3him9lmal10cyxifasf75x4h5b239wawpx3vzgim23xq3";
  })
  (fetchNuGet {
    name = "System.Net.Http";
    version = "4.3.0";
    sha256 = "1i4gc757xqrzflbk7kc5ksn20kwwfjhw9w7pgdkn19y3cgnl302j";
  })
  (fetchNuGet {
    name = "MimeKit";
    version = "2.1.4";
    sha256 = "0d80djhg732h0ywmv9hcy43kphsnv78qs8r8cdcma4vfb1r9i43p";
  })
  (fetchNuGet {
    name = "Microsoft.CSharp";
    version = "4.6.0";
    sha256 = "0yxh81v5lyc82y675gx79shzy58rlb1y24mniiz1hbyglq89v8yp";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.FileProviders.Physical";
    version = "2.2.0";
    sha256 = "0lrq4bxf67pw6n9kzwzqsnxkad2ygh2zn46hjias8j7aqljglh7x";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.DependencyInjection.Abstractions";
    version = "2.1.0";
    sha256 = "0c0cx8r5xkjpxmcfp51959jnp55qjvq28d9vaslk08avvi1by12s";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging.Abstractions";
    version = "2.1.0";
    sha256 = "1gvgif1wcx4k6pv7gc00qv1hid945jdywy1s50s33q0hfd91hbnj";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Options";
    version = "2.1.0";
    sha256 = "0w9644sryd1c6r3n4lq2cgd5pn6jl3k5m38a05m7vjffa4m2spd2";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.Binder";
    version = "2.1.0";
    sha256 = "0x1888w5ypavvszfmpja9krgc64527prs75vm8xbf9fv3rgsplql";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Primitives";
    version = "2.2.0";
    sha256 = "0znah6arbcqari49ymigg3wiy2hgdifz8zsq8vdc3ynnf45r7h0c";
  })
  (fetchNuGet {
    name = "System.ComponentModel.Annotations";
    version = "4.5.0";
    sha256 = "1jj6f6g87k0iwsgmg3xmnn67a14mq88np0l1ys5zkxhkvbc8976p";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging.Abstractions";
    version = "2.2.0";
    sha256 = "02w7hp6jicr7cl5p456k2cmrjvvhm6spg5kxnlncw3b72358m5wl";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.ObjectPool";
    version = "2.2.0";
    sha256 = "0n1q9lvc24ii1shzy575xldgmz7imnk4dswwwcgmzz93klri9r1z";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.WebUtilities";
    version = "2.2.0";
    sha256 = "0cs1g4ing4alfbwyngxzgvkrv7z964isv1j9dzflafda4p0wxmsi";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Http.Abstractions";
    version = "2.2.0";
    sha256 = "13s8cm6jdpydxmr0rgmzrmnp1v2r7i3rs7v9fhabk5spixdgfy6b";
  })
  (fetchNuGet {
    name = "Microsoft.Net.Http.Headers";
    version = "2.2.0";
    sha256 = "0w6lrk9z67bcirq2cj2ldfhnizc6id77ba6i30hjzgqjlyhh1gx5";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging.Configuration";
    version = "2.1.1";
    sha256 = "1qjri8c506928ld7mnyi1cdw08736yzqnlalghkbalhi82bcr3vq";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.UserSecrets";
    version = "2.1.1";
    sha256 = "1w36xzrxvs2p6lip7dshgpl1n331rbdrgxz59x42fzywsnrg3kfb";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging.Debug";
    version = "2.1.1";
    sha256 = "14wb3kjgd801v4lqjsfif7r347xz3krcy7ljmzjy8gs93rfgbzr8";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.EnvironmentVariables";
    version = "2.1.1";
    sha256 = "0b7f3fjdnfdm7qzqnbym344rbv8fh9qmngqnz5q1c2rapm9s6si8";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging";
    version = "2.1.1";
    sha256 = "12pag6rf01xfa8x1h30mf4czfhlhg2kgi5q712jicy3h12c02w8y";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.HostFiltering";
    version = "2.1.1";
    sha256 = "0sq2hjvxsni24ah8dsp0ap52cjk7f6m538x5v2zw6l4ksd486c65";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Routing";
    version = "2.1.1";
    sha256 = "065vy9nxcn87am2yxj918gs82g564jv1yfygfiygvw9wbvrfx8bd";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.FileExtensions";
    version = "2.1.1";
    sha256 = "0nfydlxvgs7bxqamj0jww1wwxbipzm30ygxabk29zx9q1r0qbnx5";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging.Console";
    version = "2.1.1";
    sha256 = "02jgxk4blj0gpbvndfih5mngqdhpmcsmcmpv6pds830b2by4dmcj";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.CommandLine";
    version = "2.1.1";
    sha256 = "0kz8khgnd57hjjlws25lcrw2459ycly9d1nxsv2k3gag7d1p09xw";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Server.IISIntegration";
    version = "2.1.7";
    sha256 = "1vilwzx018qqxxbcky8rpbyj08x51nl6s19k1aal9liq73m54x0z";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Server.Kestrel";
    version = "2.1.3";
    sha256 = "1lcn2j2ps2d0rhry806shf9nfkcbqlysvx49qda7xszaz7xyjqji";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Server.Kestrel.Https";
    version = "2.1.3";
    sha256 = "193wz686iixqbi4mcxqffjj7rl9fnb7iln52iwly54sa1lwffqa9";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Hosting";
    version = "2.1.1";
    sha256 = "1prlc9qgwqvs0w3sjrbk9q8fhaq0l0pnvwyxa6gqcb0x82vmlhsl";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Diagnostics";
    version = "2.1.1";
    sha256 = "1rb0qh48mm7p0gk21h3vvjgf6rxqpy5f4mj2m16jyzlr9373wzav";
  })
  (fetchNuGet {
    name = "System.Reflection.Emit.ILGeneration";
    version = "4.3.0";
    sha256 = "0w1n67glpv8241vnpz1kl14sy7zlnw414aqwj4hcx5nd86f6994q";
  })
  (fetchNuGet {
    name = "System.Reflection.Primitives";
    version = "4.3.0";
    sha256 = "04xqa33bld78yv5r93a8n76shvc8wwcdgr1qvvjh959g3rc31276";
  })
  (fetchNuGet {
    name = "System.Reflection";
    version = "4.3.0";
    sha256 = "0xl55k0mw8cd8ra6dxzh974nxif58s3k1rjv1vbd7gjbjr39j11m";
  })
  (fetchNuGet {
    name = "Microsoft.NETCore.Targets";
    version = "1.1.0";
    sha256 = "193xwf33fbm0ni3idxzbr5fdq3i2dlfgihsac9jj7whj0gd902nh";
  })
  (fetchNuGet {
    name = "System.Private.ServiceModel";
    version = "4.5.3";
    sha256 = "0nyw9m9dj327hn0qb0jmgwpch0f40jv301fk4mrchga8g99xbpng";
  })
  (fetchNuGet {
    name = "runtime.native.System.Data.SqlClient.sni";
    version = "4.4.0";
    sha256 = "15wnpyy506q3vyk1yzdjjf49zpdynr7ghh0x5fbz4pcc1if0p9ky";
  })
  (fetchNuGet {
    name = "System.Security.Principal.Windows";
    version = "4.4.0";
    sha256 = "11rr16fp68apc0arsymgj18w8ajs9a4366wgx9iqwny4glrl20wp";
  })
  (fetchNuGet {
    name = "Microsoft.Win32.Registry";
    version = "4.4.0";
    sha256 = "088j2anh1rnkxdcycw5kgp97ahk7cj741y6kask84880835arsb6";
  })
  (fetchNuGet {
    name = "System.Text.Encoding.CodePages";
    version = "4.4.0";
    sha256 = "07bzjnflxjk9vgpljfybrpqmvsr9qr2f20nq5wf11imwa5pbhgfc";
  })
  (fetchNuGet {
    name = "System.Diagnostics.Tracing";
    version = "4.3.0";
    sha256 = "1m3bx6c2s958qligl67q7grkwfz3w53hpy7nc97mh6f7j5k168c4";
  })
  (fetchNuGet {
    name = "System.Net.Primitives";
    version = "4.3.0";
    sha256 = "0c87k50rmdgmxx7df2khd9qj7q35j9rzdmm2572cc55dygmdk3ii";
  })
  (fetchNuGet {
    name = "System.Net.WebHeaderCollection";
    version = "4.3.0";
    sha256 = "0ms3ddjv1wn8sqa5qchm245f3vzzif6l6fx5k92klqpn7zf4z562";
  })
  (fetchNuGet {
    name = "runtime.native.System.Net.Http";
    version = "4.3.0";
    sha256 = "1n6rgz5132lcibbch1qlf0g9jk60r0kqv087hxc0lisy50zpm7kk";
  })
  (fetchNuGet {
    name = "System.Diagnostics.DiagnosticSource";
    version = "4.3.0";
    sha256 = "0z6m3pbiy0qw6rn3n209rrzf9x1k4002zh90vwcrsym09ipm2liq";
  })
  (fetchNuGet {
    name = "System.Security.Cryptography.Algorithms";
    version = "4.3.0";
    sha256 = "03sq183pfl5kp7gkvq77myv7kbpdnq3y0xj7vi4q1kaw54sny0ml";
  })
  (fetchNuGet {
    name = "System.Security.Cryptography.Encoding";
    version = "4.3.0";
    sha256 = "1jr6w70igqn07k5zs1ph6xja97hxnb3mqbspdrff6cvssgrixs32";
  })
  (fetchNuGet {
    name = "System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0givpvvj8yc7gv4lhb6s1prq6p2c4147204a0wib89inqzd87gqc";
  })
  (fetchNuGet {
    name = "System.Security.Cryptography.Primitives";
    version = "4.3.0";
    sha256 = "0pyzncsv48zwly3lw4f2dayqswcfvdwq2nz0dgwmi7fj3pn64wby";
  })
  (fetchNuGet {
    name = "System.Security.Cryptography.X509Certificates";
    version = "4.3.0";
    sha256 = "0valjcz5wksbvijylxijjxb1mp38mdhv03r533vnx1q3ikzdav9h";
  })
  (fetchNuGet {
    name = "runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0zy5r25jppz48i2bkg8b9lfig24xixg6nm3xyr1379zdnqnpm8f6";
  })
  (fetchNuGet {
    name = "System.Diagnostics.Debug";
    version = "4.0.11";
    sha256 = "0gmjghrqmlgzxivd2xl50ncbglb7ljzb66rlx8ws6dv8jm0d5siz";
  })
  (fetchNuGet {
    name = "System.Resources.ResourceManager";
    version = "4.0.1";
    sha256 = "0b4i7mncaf8cnai85jv3wnw6hps140cxz8vylv2bik6wyzgvz7bi";
  })
  (fetchNuGet {
    name = "System.Collections";
    version = "4.0.11";
    sha256 = "1ga40f5lrwldiyw6vy67d0sg7jd7ww6kgwbksm19wrvq9hr0bsm6";
  })
  (fetchNuGet {
    name = "System.Runtime.InteropServices";
    version = "4.1.0";
    sha256 = "01kxqppx3dr3b6b286xafqilv4s2n0gqvfgzfd4z943ga9i81is1";
  })
  (fetchNuGet {
    name = "System.Runtime.Extensions";
    version = "4.1.0";
    sha256 = "0rw4rm4vsm3h3szxp9iijc3ksyviwsv6f63dng3vhqyg4vjdkc2z";
  })
  (fetchNuGet {
    name = "System.Globalization";
    version = "4.0.11";
    sha256 = "070c5jbas2v7smm660zaf1gh0489xanjqymkvafcs4f8cdrs1d5d";
  })
  (fetchNuGet {
    name = "System.Memory";
    version = "4.5.0";
    sha256 = "1layqpcx1q4l805fdnj2dfqp6ncx2z42ca06rgsr6ikq4jjgbv30";
  })
  (fetchNuGet {
    name = "System.Reflection";
    version = "4.1.0";
    sha256 = "1js89429pfw79mxvbzp8p3q93il6rdff332hddhzi5wqglc4gml9";
  })
  (fetchNuGet {
    name = "System.Collections.Concurrent";
    version = "4.0.12";
    sha256 = "07y08kvrzpak873pmyxs129g1ch8l27zmg51pcyj2jvq03n0r0fc";
  })
  (fetchNuGet {
    name = "System.Linq";
    version = "4.1.0";
    sha256 = "1ppg83svb39hj4hpp5k7kcryzrf3sfnm08vxd5sm2drrijsla2k5";
  })
  (fetchNuGet {
    name = "System.Console";
    version = "4.3.0";
    sha256 = "1flr7a9x920mr5cjsqmsy9wgnv3lvd0h1g521pdr1lkb2qycy7ay";
  })
  (fetchNuGet {
    name = "System.Threading.Timer";
    version = "4.3.0";
    sha256 = "1nx773nsx6z5whv8kaa1wjh037id2f1cxhb69pvgv12hd2b6qs56";
  })
  (fetchNuGet {
    name = "System.Diagnostics.Tools";
    version = "4.3.0";
    sha256 = "0in3pic3s2ddyibi8cvgl102zmvp9r9mchh82ns9f0ms4basylw1";
  })
  (fetchNuGet {
    name = "System.Net.Sockets";
    version = "4.3.0";
    sha256 = "1ssa65k6chcgi6mfmzrznvqaxk8jp0gvl77xhf1hbzakjnpxspla";
  })
  (fetchNuGet {
    name = "System.IO.Compression.ZipFile";
    version = "4.3.0";
    sha256 = "1yxy5pq4dnsm9hlkg9ysh5f6bf3fahqqb6p8668ndy5c0lk7w2ar";
  })
  (fetchNuGet {
    name = "System.Globalization.Calendars";
    version = "4.3.0";
    sha256 = "1xwl230bkakzzkrggy1l1lxmm3xlhk4bq2pkv790j5lm8g887lxq";
  })
  (fetchNuGet {
    name = "System.AppContext";
    version = "4.3.0";
    sha256 = "1649qvy3dar900z3g817h17nl8jp4ka5vcfmsr05kh0fshn7j3ya";
  })
  (fetchNuGet {
    name = "System.Reflection.Extensions";
    version = "4.3.0";
    sha256 = "02bly8bdc98gs22lqsfx9xicblszr2yan7v2mmw3g7hy6miq5hwq";
  })
  (fetchNuGet {
    name = "System.Runtime.Numerics";
    version = "4.3.0";
    sha256 = "19rav39sr5dky7afygh309qamqqmi9kcwvz3i0c5700v0c5cg61z";
  })
  (fetchNuGet {
    name = "System.Runtime.InteropServices.RuntimeInformation";
    version = "4.3.0";
    sha256 = "0q18r1sh4vn7bvqgd6dmqlw5v28flbpj349mkdish2vjyvmnb2ii";
  })
  (fetchNuGet {
    name = "System.Linq";
    version = "4.3.0";
    sha256 = "1w0gmba695rbr80l1k2h4mrwzbzsyfl2z4klmpbsvsg5pm4a56s7";
  })
  (fetchNuGet {
    name = "System.IO.Compression";
    version = "4.3.0";
    sha256 = "084zc82yi6yllgda0zkgl2ys48sypiswbiwrv7irb3r0ai1fp4vz";
  })
  (fetchNuGet {
    name = "System.Collections.Concurrent";
    version = "4.3.0";
    sha256 = "0wi10md9aq33jrkh2c24wr2n9hrpyamsdhsxdcnf43b7y86kkii8";
  })
  (fetchNuGet {
    name = "System.ObjectModel";
    version = "4.3.0";
    sha256 = "191p63zy5rpqx7dnrb3h7prvgixmk168fhvvkkvhlazncf8r3nc2";
  })
  (fetchNuGet {
    name = "System.Runtime.CompilerServices.Unsafe";
    version = "4.5.0";
    sha256 = "17labczwqk3jng3kkky73m0jhi8wc21vbl7cz5c0hj2p1dswin43";
  })
  (fetchNuGet {
    name = "System.Xml.XDocument";
    version = "4.3.0";
    sha256 = "08h8fm4l77n0nd4i4fk2386y809bfbwqb7ih9d7564ifcxr5ssxd";
  })
  (fetchNuGet {
    name = "System.Text.RegularExpressions";
    version = "4.3.0";
    sha256 = "1bgq51k7fwld0njylfn7qc5fmwrk2137gdq7djqdsw347paa9c2l";
  })
  (fetchNuGet {
    name = "System.Xml.ReaderWriter";
    version = "4.3.0";
    sha256 = "0c47yllxifzmh8gq6rq6l36zzvw4kjvlszkqa9wq3fr59n0hl3s1";
  })
  (fetchNuGet {
    name = "System.Linq.Expressions";
    version = "4.3.0";
    sha256 = "0ky2nrcvh70rqq88m9a5yqabsl4fyd17bpr63iy2mbivjs2nyypv";
  })
  (fetchNuGet {
    name = "System.Threading.Overlapped";
    version = "4.3.0";
    sha256 = "1nahikhqh9nk756dh8p011j36rlcp1bzz3vwi2b4m1l2s3vz8idm";
  })
  (fetchNuGet {
    name = "System.Security.Principal.Windows";
    version = "4.3.0";
    sha256 = "00a0a7c40i3v4cb20s2cmh9csb5jv2l0frvnlzyfxh848xalpdwr";
  })
  (fetchNuGet {
    name = "runtime.native.System.Net.Security";
    version = "4.3.0";
    sha256 = "0dnqjhw445ay3chpia9p6vy4w2j6s9vy3hxszqvdanpvvyaxijr3";
  })
  (fetchNuGet {
    name = "runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "18pzfdlwsg2nb1jjjjzyb5qlgy6xjxzmhnfaijq5s2jw3cm3ab97";
  })
  (fetchNuGet {
    name = "System.Security.Principal";
    version = "4.3.0";
    sha256 = "12cm2zws06z4lfc4dn31iqv7072zyi4m910d4r6wm8yx85arsfxf";
  })
  (fetchNuGet {
    name = "System.Security.Claims";
    version = "4.3.0";
    sha256 = "0jvfn7j22l3mm28qjy3rcw287y9h65ha4m940waaxah07jnbzrhn";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.FileSystemGlobbing";
    version = "2.2.0";
    sha256 = "01jw7s1nb44n65qs3rk7xdzc419qwl0s5c34k031f1cc5ag3jvc2";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.FileProviders.Abstractions";
    version = "2.2.0";
    sha256 = "1f83ffb4xjwljg8dgzdsa3pa0582q6b4zm0si467fgkybqzk3c54";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Primitives";
    version = "2.1.0";
    sha256 = "1r9gzwdfmb8ysnc4nzmyz5cyar1lw0qmizsvrsh252nhlyg06nmb";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration";
    version = "2.1.0";
    sha256 = "04rjl38wlr1jjjpbzgf64jp0ql6sbzbil0brwq9mgr3hdgwd7vx2";
  })
  (fetchNuGet {
    name =
      "runtime.opensuse.42.1-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "1klrs545awhayryma6l7g2pvnp9xy4z0r1i40r80zb45q3i9nbyf";
  })
  (fetchNuGet {
    name = "System.Runtime.CompilerServices.Unsafe";
    version = "4.5.1";
    sha256 = "1xcrjx5fwg284qdnxyi2d0lzdm5q4frlpkp0nf6vvkx1kdz2prrf";
  })
  (fetchNuGet {
    name = "System.Memory";
    version = "4.5.1";
    sha256 = "0f07d7hny38lq9w69wx4lxkn4wszrqf9m9js6fh9is645csm167c";
  })
  (fetchNuGet {
    name = "System.Text.Encodings.Web";
    version = "4.5.0";
    sha256 = "0srd5bva52n92i90wd88pzrqjsxnfgka3ilybwh7s6sf469y5s53";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Http.Features";
    version = "2.2.0";
    sha256 = "0xrlq8i61vzhzzy25n80m7wh2kn593rfaii3aqnxdsxsg6sfgnx1";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration";
    version = "2.1.1";
    sha256 = "0244czr3jflvzcj6axq61j10dkl0f16ad34rw81ryg57v4cvlwx6";
  })
  (fetchNuGet {
    name =
      "runtime.fedora.24-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0c2p354hjx58xhhz7wv6div8xpi90sc6ibdm40qin21bvi7ymcaa";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Logging.Abstractions";
    version = "2.1.1";
    sha256 = "1sgpwj0sa0ac7m5fnkb482mnch8fsv8hfbvk53c6lyh47s1xhdjg";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.DependencyInjection.Abstractions";
    version = "2.1.1";
    sha256 = "0rn0925aqm1fsbaf0n8jy6ng2fm1cy97lp7yikvx31m6178k9i84";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.Binder";
    version = "2.1.1";
    sha256 = "0n91s6cjfv8plf5swhr307s849jmq2pa3i1rbpb0cb0grxml0mqm";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Options";
    version = "2.1.1";
    sha256 = "0wgpsi874gzzjj099xbdmmsifslkbdjkxd5xrzpc5xdglpkw08vl";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Hosting.Abstractions";
    version = "2.1.1";
    sha256 = "1wnlcnaqfv3xpmhi5rpkn1r6bfrpv3pb8rvfz9dk5l87mllpi5mm";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Http";
    version = "2.1.1";
    sha256 = "04b9szil8ndw7k991m3x56xlm8pav0ap1caa9b23ik3jyavzq22a";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Http.Extensions";
    version = "2.1.1";
    sha256 = "01nbz8gl12bjcrw52z5w61khlzn02wngdkc68fsy7pl74vrzj69v";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.ObjectPool";
    version = "2.1.1";
    sha256 = "1rc1f9pqjljgqp670i3a4v8y4bsydcbm6mpmhw2dq753cg90gx4a";
  })
  (fetchNuGet {
    name =
      "runtime.opensuse.13.2-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0qyynf9nz5i7pc26cwhgi8j62ps27sqmf78ijcfgzab50z9g8ay3";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Routing.Abstractions";
    version = "2.1.1";
    sha256 = "04dx2ysk34x4vy1q0sxsqhzmfcxkn438k4fbsz5z8m0x6kdiv9gi";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.FileProviders.Physical";
    version = "2.1.1";
    sha256 = "13rharvsycfk0056fbcx55npp9py7ng3hgcsasz1inva3q9lcngj";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Configuration.Abstractions";
    version = "2.1.1";
    sha256 = "0b4bn0cf39c6jlc8xnpi1d8f3pz0qhf8ng440yb95y5jv5q4fdyw";
  })
  (fetchNuGet {
    name = "System.Numerics.Vectors";
    version = "4.5.0";
    sha256 = "1kzrj37yzawf1b19jq0253rcs8hsq1l2q8g69d7ipnhzb0h97m59";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.HttpOverrides";
    version = "2.1.1";
    sha256 = "0gml9rb102cahpqg09dkim068w99qibq6bcf3z3ij2x4sv12hrss";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Authentication.Core";
    version = "2.1.1";
    sha256 = "05xw9g0rijma7hvimhsxb69ibj4ykf3c6qnlsi8xl7c8lz25j8i4";
  })
  (fetchNuGet {
    name = "System.IO.Pipelines";
    version = "4.5.3";
    sha256 = "1z44vn1qp866lkx78cfqdd4vs7xn1hcfn7in6239sq2kgf5qiafb";
  })
  (fetchNuGet {
    name = "System.Security.Principal.Windows";
    version = "4.5.1";
    sha256 = "1mv5mz5j7fqy0v9m2ky92wkh1ksmybhxqqqzllbp26z3rwyv07r4";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Server.Kestrel.Transport.Sockets";
    version = "2.1.3";
    sha256 = "1h0k08qf2fn59hjgizi1820r7kzai1xw7rq76s7hc7hi85pfb2hz";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Server.Kestrel.Core";
    version = "2.1.3";
    sha256 = "0y0sih22khcy3kn0bcs7akwknw541f2d5ziiz72437zbcmbgmlmz";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Http.Abstractions";
    version = "2.1.1";
    sha256 = "02jsghkbfjz0rvrnfz5pakv8dpyfcc3wjxmj4rpp0fc2mmpibkys";
  })
  (fetchNuGet {
    name = "System.Diagnostics.DiagnosticSource";
    version = "4.5.0";
    sha256 = "1y8m0p3127nak5yspapfnz25qc9x53gqpvwr3hdpsvrcd2r1pgyj";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.DependencyInjection";
    version = "2.1.1";
    sha256 = "1ll7kmp8csngy27azxh0vcli2w4sgvamqh11c9z5d4spjh6jzxcp";
  })
  (fetchNuGet {
    name = "Microsoft.Extensions.Hosting.Abstractions";
    version = "2.1.1";
    sha256 = "1vgiby2slglmwg4kjxyn6cmb3xksps6i6c9z11za6s8d2czjl90l";
  })
  (fetchNuGet {
    name = "System.Reflection.Metadata";
    version = "1.6.0";
    sha256 = "1wdbavrrkajy7qbdblpbpbalbdl48q3h34cchz24gvdgyrlf15r4";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.Diagnostics.Abstractions";
    version = "2.1.1";
    sha256 = "0mba7jcj4sfw5fbfwv00h1657m95l4f4zbrc0gkfcw2mv7kl6s8h";
  })
  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "2.1.0";
    sha256 = "0nmdnkmwyxj8cp746hs9an57zspqlmqdm55b00i7yk8a22s6akxz";
  })
  (fetchNuGet {
    name = "System.Security.Principal.Windows";
    version = "4.5.0";
    sha256 = "0rmj89wsl5yzwh0kqjgx45vzf694v9p92r4x4q6yxldk1cv1hi86";
  })
  (fetchNuGet {
    name = "System.Reflection.DispatchProxy";
    version = "4.5.0";
    sha256 = "0v9sg38h91aljvjyc77m1y5v34p50hjdbxvvxwa1whlajhafadcn";
  })
  (fetchNuGet {
    name = "runtime.win-arm64.runtime.native.System.Data.SqlClient.sni";
    version = "4.4.0";
    sha256 = "07byf1iyqb7jkb17sp0mmjk46fwq6fx8mlpzywxl7qk09sma44gk";
  })
  (fetchNuGet {
    name = "runtime.win-x86.runtime.native.System.Data.SqlClient.sni";
    version = "4.4.0";
    sha256 = "0k3rkfrlm9jjz56dra61jgxinb8zsqlqzik2sjwz7f8v6z6ddycc";
  })
  (fetchNuGet {
    name = "Microsoft.AspNetCore.WebUtilities";
    version = "2.1.1";
    sha256 = "1744g3c04bz27lafx0q90cg0i17rahymgckbhggn1147pxs3lgpv";
  })
  (fetchNuGet {
    name = "runtime.win-x64.runtime.native.System.Data.SqlClient.sni";
    version = "4.4.0";
    sha256 = "0167s4mpq8bzk3y11pylnynzjr2nc84w96al9x4l8yrf34ccm18y";
  })
  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "2.0.0";
    sha256 = "1fk2fk2639i7nzy58m9dvpdnzql4vb8yl8vr19r2fp8lmj9w2jr0";
  })
  (fetchNuGet {
    name = "System.Security.AccessControl";
    version = "4.4.0";
    sha256 = "0ixqw47krkazsw0ycm22ivkv7dpg6cjz8z8g0ii44bsx4l8gcx17";
  })
  (fetchNuGet {
    name = "runtime.native.System.Security.Cryptography.Apple";
    version = "4.3.0";
    sha256 = "1b61p6gw1m02cc1ry996fl49liiwky6181dzr873g9ds92zl326q";
  })
  (fetchNuGet {
    name = "System.Security.Cryptography.Cng";
    version = "4.3.0";
    sha256 = "1k468aswafdgf56ab6yrn7649kfqx2wm9aslywjam1hdmk5yypmv";
  })
  (fetchNuGet {
    name = "System.Security.Cryptography.Csp";
    version = "4.3.0";
    sha256 = "1x5wcrddf2s3hb8j78cry7yalca4lb5vfnkrysagbn6r9x6xvrx1";
  })
  (fetchNuGet {
    name =
      "runtime.opensuse.13.2-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "096ch4n4s8k82xga80lfmpimpzahd2ip1mgwdqgar0ywbbl6x438";
  })
  (fetchNuGet {
    name =
      "runtime.ubuntu.14.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "15gsm1a8jdmgmf8j5v1slfz8ks124nfdhk2vxs2rw3asrxalg8hi";
  })
  (fetchNuGet {
    name =
      "runtime.rhel.7-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1cpx56mcfxz7cpn57wvj18sjisvzq8b5vd9rw16ihd2i6mcp3wa1";
  })
  (fetchNuGet {
    name =
      "runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0rwpqngkqiapqc5c2cpkj7idhngrgss5qpnqg0yh40mbyflcxf8i";
  })
  (fetchNuGet {
    name =
      "runtime.fedora.23-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1n06gxwlinhs0w7s8a94r1q3lwqzvynxwd3mp10ws9bg6gck8n4r";
  })
  (fetchNuGet {
    name =
      "runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1m9z1k9kzva9n9kwinqxl97x2vgl79qhqjlv17k9s2ymcyv2bwr6";
  })
  (fetchNuGet {
    name =
      "runtime.ubuntu.16.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0q0n5q1r1wnqmr5i5idsrd9ywl33k0js4pngkwq9p368mbxp8x1w";
  })
  (fetchNuGet {
    name =
      "runtime.fedora.24-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0404wqrc7f2yc0wxv71y3nnybvqx8v4j9d47hlscxy759a525mc3";
  })
  (fetchNuGet {
    name =
      "runtime.opensuse.42.1-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1dm8fifl7rf1gy7lnwln78ch4rw54g0pl5g1c189vawavll7p6rj";
  })
  (fetchNuGet {
    name =
      "runtime.ubuntu.16.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1x0g58pbpjrmj2x2qw17rdwwnrcl0wvim2hdwz48lixvwvp22n9c";
  })
  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "1.0.1";
    sha256 = "01al6cfxp68dscl15z7rxfw9zvhm64dncsw09a1vmdkacsa2v6lr";
  })
  (fetchNuGet {
    name = "Microsoft.NETCore.Targets";
    version = "1.0.1";
    sha256 = "0ppdkwy6s9p7x9jix3v4402wb171cdiibq7js7i13nxpdky7074p";
  })
  (fetchNuGet {
    name = "System.Runtime";
    version = "4.1.0";
    sha256 = "02hdkgk13rvsd6r9yafbwzss8kr55wnj8d5c7xjnp8gqrwc8sn0m";
  })
  (fetchNuGet {
    name = "System.Reflection.Primitives";
    version = "4.0.1";
    sha256 = "1bangaabhsl4k9fg8khn83wm6yial8ik1sza7401621jc6jrym28";
  })
  (fetchNuGet {
    name = "System.Runtime.Handles";
    version = "4.0.1";
    sha256 = "1g0zrdi5508v49pfm3iii2hn6nm00bgvfpjq1zxknfjrxxa20r4g";
  })
  (fetchNuGet {
    name = "System.IO";
    version = "4.1.0";
    sha256 = "1g0yb8p11vfd0kbkyzlfsbsp5z44lwsvyc0h3dpw6vqnbi035ajp";
  })
  (fetchNuGet {
    name = "System.Diagnostics.Tracing";
    version = "4.1.0";
    sha256 = "1d2r76v1x610x61ahfpigda89gd13qydz6vbwzhpqlyvq8jj6394";
  })
  (fetchNuGet {
    name = "System.Threading.Tasks";
    version = "4.0.11";
    sha256 = "0nr1r41rak82qfa5m0lhk9mp0k93bvfd7bbd9sdzwx9mb36g28p5";
  })
  (fetchNuGet {
    name = "System.Threading";
    version = "4.0.11";
    sha256 = "19x946h926bzvbsgj28csn46gak2crv2skpwsx80hbgazmkgb1ls";
  })
  (fetchNuGet {
    name = "System.Buffers";
    version = "4.3.0";
    sha256 = "0fgns20ispwrfqll4q1zc1waqcmylb3zc50ys9x8zlwxh9pmd9jy";
  })
  (fetchNuGet {
    name = "runtime.native.System.IO.Compression";
    version = "4.3.0";
    sha256 = "1vvivbqsk6y4hzcid27pqpm5bsi6sc50hvqwbcx8aap5ifrxfs8d";
  })
  (fetchNuGet {
    name = "System.Threading.Tasks.Extensions";
    version = "4.3.0";
    sha256 = "1xxcx2xh8jin360yjwm4x4cf5y3a2bwpn2ygkfkwkicz7zk50s2z";
  })
  (fetchNuGet {
    name =
      "runtime.rhel.7-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0vhynn79ih7hw7cwjazn87rm9z9fj0rvxgzlab36jybgcpcgphsn";
  })
  (fetchNuGet {
    name =
      "runtime.ubuntu.16.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "1p4dgxax6p7rlgj4q73k73rslcnz4wdcv8q2flg1s8ygwcm58ld5";
  })
  (fetchNuGet {
    name =
      "runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0zcxjv5pckplvkg0r6mw3asggm7aqzbdjimhvsasb0cgm59x09l3";
  })
  (fetchNuGet {
    name =
      "runtime.ubuntu.14.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "160p68l2c7cqmyqjwxydcvgw7lvl1cr0znkw8fp24d1by9mqc8p3";
  })
  (fetchNuGet {
    name =
      "runtime.ubuntu.16.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "15zrc8fgd8zx28hdghcj5f5i34wf3l6bq5177075m2bc2j34jrqy";
  })
  (fetchNuGet {
    name =
      "runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "16rnxzpk5dpbbl1x354yrlsbvwylrq456xzpsha1n9y3glnhyx9d";
  })
  (fetchNuGet {
    name =
      "runtime.fedora.23-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0hkg03sgm2wyq8nqk6dbm9jh5vcq57ry42lkqdmfklrw89lsmr59";
  })
  (fetchNuGet {
    name = "runtime.unix.System.Private.Uri";
    version = "4.3.0";
    sha256 = "1jx02q6kiwlvfksq1q9qr17fj78y5v6mwsszav4qcz9z25d5g6vk";
  })
  (fetchNuGet {
    name = "runtime.any.System.Globalization.Calendars";
    version = "4.3.0";
    sha256 = "1ghhhk5psqxcg6w88sxkqrc35bxcz27zbqm2y5p5298pv3v7g201";
  })
  (fetchNuGet {
    name = "runtime.any.System.Threading.Timer";
    version = "4.3.0";
    sha256 = "0aw4phrhwqz9m61r79vyfl5la64bjxj8l34qnrcwb28v49fg2086";
  })
  (fetchNuGet {
    name = "runtime.unix.System.Console";
    version = "4.3.0";
    sha256 = "1pfpkvc6x2if8zbdzg9rnc5fx51yllprl8zkm5npni2k50lisy80";
  })
  (fetchNuGet {
    name = "runtime.any.System.Reflection.Extensions";
    version = "4.3.0";
    sha256 = "0zyri97dfc5vyaz9ba65hjj1zbcrzaffhsdlpxc9bh09wy22fq33";
  })
  (fetchNuGet {
    name = "runtime.any.System.Diagnostics.Tools";
    version = "4.3.0";
    sha256 = "1wl76vk12zhdh66vmagni66h5xbhgqq7zkdpgw21jhxhvlbcl8pk";
  })
  (fetchNuGet {
    name = "runtime.unix.System.Net.Sockets";
    version = "4.3.0";
    sha256 = "03npdxzy8gfv035bv1b9rz7c7hv0rxl5904wjz51if491mw0xy12";
  })
  (fetchNuGet {
    name = "runtime.unix.System.Net.Primitives";
    version = "4.3.0";
    sha256 = "0bdnglg59pzx9394sy4ic66kmxhqp8q8bvmykdxcbs5mm0ipwwm4";
  })
  (fetchNuGet {
    name = "runtime.any.System.Diagnostics.Tracing";
    version = "4.3.0";
    sha256 = "00j6nv2xgmd3bi347k00m7wr542wjlig53rmj28pmw7ddcn97jbn";
  })
  (fetchNuGet {
    name = "System.Private.Uri";
    version = "4.3.0";
    sha256 = "04r1lkdnsznin0fj4ya1zikxiqr0h6r6a1ww2dsm60gqhdrf0mvx";
  })
  (fetchNuGet {
    name = "runtime.any.System.Reflection";
    version = "4.3.0";
    sha256 = "02c9h3y35pylc0zfq3wcsvc5nqci95nrkq0mszifc0sjx7xrzkly";
  })
  (fetchNuGet {
    name = "runtime.any.System.Reflection.Primitives";
    version = "4.3.0";
    sha256 = "0x1mm8c6iy8rlxm8w9vqw7gb7s1ljadrn049fmf70cyh42vdfhrf";
  })
  (fetchNuGet {
    name = "runtime.any.System.Runtime";
    version = "4.3.0";
    sha256 = "1cqh1sv3h5j7ixyb7axxbdkqx6cxy00p4np4j91kpm492rf4s25b";
  })
  (fetchNuGet {
    name = "runtime.unix.System.Runtime.Extensions";
    version = "4.3.0";
    sha256 = "0pnxxmm8whx38dp6yvwgmh22smknxmqs5n513fc7m4wxvs1bvi4p";
  })
  (fetchNuGet {
    name = "runtime.any.System.Globalization";
    version = "4.3.0";
    sha256 = "1daqf33hssad94lamzg01y49xwndy2q97i2lrb7mgn28656qia1x";
  })
  (fetchNuGet {
    name = "runtime.unix.System.IO.FileSystem";
    version = "4.3.0";
    sha256 = "14nbkhvs7sji5r1saj2x8daz82rnf9kx28d3v2qss34qbr32dzix";
  })
  (fetchNuGet {
    name = "runtime.any.System.Text.Encoding.Extensions";
    version = "4.3.0";
    sha256 = "0lqhgqi0i8194ryqq6v2gqx0fb86db2gqknbm0aq31wb378j7ip8";
  })
  (fetchNuGet {
    name = "runtime.unix.Microsoft.Win32.Primitives";
    version = "4.3.0";
    sha256 = "0y61k9zbxhdi0glg154v30kkq7f8646nif8lnnxbvkjpakggd5id";
  })
  (fetchNuGet {
    name = "runtime.any.System.IO";
    version = "4.3.0";
    sha256 = "0l8xz8zn46w4d10bcn3l4yyn4vhb3lrj2zw8llvz7jk14k4zps5x";
  })
  (fetchNuGet {
    name = "runtime.any.System.Threading.Tasks";
    version = "4.3.0";
    sha256 = "03mnvkhskbzxddz4hm113zsch1jyzh2cs450dk3rgfjp8crlw1va";
  })
  (fetchNuGet {
    name = "runtime.any.System.Text.Encoding";
    version = "4.3.0";
    sha256 = "0aqqi1v4wx51h51mk956y783wzags13wa7mgqyclacmsmpv02ps3";
  })
  (fetchNuGet {
    name = "runtime.unix.System.Diagnostics.Debug";
    version = "4.3.0";
    sha256 = "1lps7fbnw34bnh3lm31gs5c0g0dh7548wfmb8zz62v0zqz71msj5";
  })
  (fetchNuGet {
    name = "runtime.any.System.Runtime.Handles";
    version = "4.3.0";
    sha256 = "0bh5bi25nk9w9xi8z23ws45q5yia6k7dg3i4axhfqlnj145l011x";
  })
  (fetchNuGet {
    name = "runtime.any.System.Runtime.InteropServices";
    version = "4.3.0";
    sha256 = "0c3g3g3jmhlhw4klrc86ka9fjbl7i59ds1fadsb2l8nqf8z3kb19";
  })
  (fetchNuGet {
    name = "runtime.any.System.Resources.ResourceManager";
    version = "4.3.0";
    sha256 = "03kickal0iiby82wa5flar18kyv82s9s6d4xhk5h4bi5kfcyfjzl";
  })
  (fetchNuGet {
    name = "runtime.any.System.Collections";
    version = "4.3.0";
    sha256 = "0bv5qgm6vr47ynxqbnkc7i797fdi8gbjjxii173syrx14nmrkwg0";
  })
]
